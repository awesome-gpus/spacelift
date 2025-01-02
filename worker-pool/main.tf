resource "helm_release" "spacelift_kubernetes_workers" {
  name = "spacelift-workerpool-controller"

  repository = "https://downloads.spacelift.io/helm"
  chart      = "spacelift-workerpool-controller"

  namespace        = "spacelift-worker-controller-system"
  create_namespace = true
}

resource "kubernetes_secret" "workerpool_creds" {

  metadata {
    name      = "workerpool-creds"
    namespace = "spacelift-worker-controller-system"
  }

  data = {
    token      = var.worker_pool_config
    privateKey = var.worker_pool_private_key
  }
}

resource "kubernetes_manifest" "openfaas_fn_showcow" {
  manifest = {
    "apiVersion" = "workers.spacelift.io/v1beta1"
    "kind"       = "WorkerPool"
    "metadata" = {
      "name"      = "workerpool"
      "namespace" = "spacelift-worker-controller-system"
    }
    "spec" = {
      "poolSize" = 2
      "token" = {
        "secretKeyRef" = {
          "name" = kubernetes_secret.workerpool_creds.metadata.0.name
          "key"  = "token"
        }
      }
      "privateKey" = {
        "secretKeyRef" = {
          "name" = kubernetes_secret.workerpool_creds.metadata.0.name
          "key"  = "privateKey"
        }
      }
    }
  }

  depends_on = [helm_release.spacelift_kubernetes_workers]
}