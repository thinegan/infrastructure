##############################################################################################################
# Datadog: Log configuration ::
# Indexes Filter - Add logs configs that you want to exclude from indexing to your account.
# Index logs will incur cost($$$), so please keep the Datadog log management clean from
# debugs and meaningless logs.
##############################################################################################################
resource "datadog_logs_index" "log_index_global" {
  name           = "global"
  daily_limit    = 20000000
  retention_days = 15
  filter {
    query = "*"
  }
  exclusion_filter {
    name       = "nginx_exclusion_kube_probe"
    is_enabled = true
    filter {
      query       = "source:nginx service:templatephpfpm status:ok \"get http 1.1 200 615\""
      sample_rate = 0.97
    }
  }
  exclusion_filter {
    name       = "nginx_exclusion_elb_healthchecker"
    is_enabled = true
    filter {
      query       = "source:nginx service:templatephpfpm status:ok \"get http 1.1 200 409\""
      sample_rate = 0.97
    }
  }
  exclusion_filter {
    name       = "kube_namespace_kube_system"
    is_enabled = true
    filter {
      query       = "kube_namespace:kube-system"
      sample_rate = 1.0 // 1.0 ~> 100% logs removal
    }
  }
  exclusion_filter {
    name       = "kube_namespace_argocd"
    is_enabled = true
    filter {
      query       = "kube_namespace:argocd"
      sample_rate = 1.0
    }
  }
  exclusion_filter {
    name       = "kube_namespace_codefresh"
    is_enabled = true
    filter {
      query       = "kube_namespace:codefresh"
      sample_rate = 1.0
    }
  }
  exclusion_filter {
    name       = "kube_namespace_argo_rollouts"
    is_enabled = true
    filter {
      query       = "kube_namespace:argo-rollouts"
      sample_rate = 1.0
    }
  }
  exclusion_filter {
    name       = "kube_namespace_monitoring"
    is_enabled = true
    filter {
      query       = "kube_namespace:monitoring"
      sample_rate = 1.0
    }
  }
  exclusion_filter {
    name       = "kube_namespace_kubecost_cloud"
    is_enabled = true
    filter {
      query       = "kube_namespace:kubecost-cloud"
      sample_rate = 1.0
    }
  }
}

resource "datadog_logs_custom_pipeline" "nginx_gen" {
  filter {
    query = "service:templatephpfpm"
  }
  name       = "nginx_gen"
  is_enabled = true
  processor {
    grok_parser {
      samples = [
        "realpath: /bitnami/nginx/conf/vhosts: No such file or directory",
        "[38;5;6mnginx [38;5;5m08:04:08.30 [0m",
        "nginx: [warn] conflicting server name \"\" on 0.0.0.0:8080, ignored",
        "subject=CN = example.com",
        ".......................++++",
      ]
      source = "message"
      grok {
        support_rules = ""
        match_rules   = <<EOT
autoFilledRule1 nginx\:\s+.*\s+conflicting\s+server\s+name\s+.*
autoFilledRule2 subject\=CN\s+\=\s+example\.com
autoFilledRule3 realpath\:\s+.*
autoFilledRule4 .*\[0m(.*)
autoFilledRule5 Getting\s+Private\s+key
autoFilledRule6 Signature\s+ok
autoFilledRule7 Generating\s+RSA\s+private\s+key,\s+4096\s+bit\s+long\s+modulus\s+\(2\s+primes\)
autoFilledRule8 .*\s+\(0x010001\)
autoFilledRule9 ^\.+\+{4}$
EOT
      }
      name       = "false-positive"
      is_enabled = true
    }
  }
  processor {
    string_builder_processor {
      name               = "Notice in attribute level"
      target             = "level"
      template           = "Notice"
      is_enabled         = true
      is_replace_missing = true
    }
  }
  processor {
    status_remapper {
      name       = "Map level to offical"
      sources    = ["level"]
      is_enabled = true
    }
  }
}


resource "datadog_logs_custom_pipeline" "templatephpfpm" {
  filter {
    query = "service:templatephpfpm"
  }
  name       = "templatephpfpm"
  is_enabled = true
  processor {
    grok_parser {
      samples = [
        "[09-Jun-2023 06:41:00] NOTICE: exiting, bye-bye!",
        "[11-Jun-2023 06:48:01] NOTICE: ready to handle connections",
        "[11-Jun-2023 06:48:01] NOTICE: fpm is running, pid 1",
        "[06-Jul-2023 05:53:42] NOTICE: Finishing ...",
        "10.38.78.79 -  06/Jul/2023:07:10:42 +0000 \"GET /index.php\" 200",
      ]
      source = "message"
      grok {
        support_rules = ""
        match_rules   = <<EOT
autoFilledRule1 .*\s+NOTICE: [exiting|ready|fpm|Finishing].*
autoFilledRule2 %%{ipv4:network.client.ip}\s+-\s+%%{date("dd/MMM/yyyy:HH:mm:ss Z"):date}\s+\"%%{word:http.method}\s+%%{notSpace:http.url}\"\s+%%{integer:http.status_code}
EOT
      }
      name       = "false-positive"
      is_enabled = true
    }
  }
  processor {
    category_processor {
      name   = "Categories status code"
      target = "http.status_category"
      category {
        name = "Error"
        filter {
          query = "@http.status_code:[500 TO 599]"
        }
      }
      category {
        name = "Warning"
        filter {
          query = "@http.status_code:[400 TO 499]"
        }
      }
      category {
        name = "OK"
        filter {
          query = "@http.status_code:[200 TO 299]"
        }
      }
      category {
        name = "Notice"
        filter {
          query = "@http.status_code:[300 TO 399]"
        }
      }
      is_enabled = true
    }
  }
  processor {
    status_remapper {
      name       = "Set the log status based as the status code value"
      sources    = ["http.status_category"]
      is_enabled = true
    }
  }
  processor {
    string_builder_processor {
      name               = "Notice in attribute level"
      target             = "level"
      template           = "Notice"
      is_enabled         = true
      is_replace_missing = true
    }
  }
  processor {
    status_remapper {
      name       = "Map level to offical"
      sources    = ["level"]
      is_enabled = true
    }
  }
}

resource "datadog_logs_custom_pipeline" "cluster_autoscaler" {
  filter {
    query = "service:cluster-autoscaler"
  }
  name       = "cluster-autoscaler"
  is_enabled = true
  processor {
    grok_parser {
      samples = [
        "k8s.io/autoscaler/cluster-autoscaler/utils/kubernetes/listers.go:309: Failed to watch *v1beta1.PodDisruptionBudget: failed to list *v1beta1.PodDisruptionBudget: the server could not find the requested resource",
      ]
      source = "message"
      grok {
        support_rules = ""
        match_rules   = <<EOT
autoFilledRule1 .*: failed to list \*v1beta1.PodDisruptionBudget:.*
EOT
      }
      name       = "false-positive"
      is_enabled = true
    }
  }
  processor {
    string_builder_processor {
      name               = "Info in attribute level"
      target             = "level"
      template           = "info"
      is_enabled         = true
      is_replace_missing = true
    }
  }
  processor {
    status_remapper {
      name       = "Map level to offical"
      sources    = ["level"]
      is_enabled = true
    }
  }
}

resource "datadog_logs_custom_pipeline" "external_dns" {
  filter {
    query = "service:external-dns"
  }
  name       = "external-dns"
  is_enabled = true
  processor {
    grok_parser {
      samples = [
        "time=\"2023-06-08T07:03:57Z\" level=info msg=\"All records are already up to date\"",
      ]
      source = "message"
      grok {
        support_rules = ""
        match_rules   = <<EOT
autoFilledRule1 .*All records are already up to date"$
EOT
      }
      name       = "false-positive"
      is_enabled = true
    }
  }
  processor {
    string_builder_processor {
      name               = "Info in attribute level"
      target             = "level"
      template           = "info"
      is_enabled         = true
      is_replace_missing = true
    }
  }
  processor {
    status_remapper {
      name       = "remapping status from level attribute"
      sources    = ["level"]
      is_enabled = true
    }
  }
}