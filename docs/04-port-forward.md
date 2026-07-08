# 04. Port Forward

Ingressに依存しない確認方法として、まずは `kubectl port-forward` を使います。

## frontend-nginx

```bash
kubectl -n demo-light port-forward svc/frontend-nginx 8080:80
```

別ターミナルで:

```bash
curl http://localhost:8080
```

## backend-httpbin

```bash
kubectl -n demo-light port-forward svc/backend-httpbin 8081:8000
```

別ターミナルで:

```bash
curl http://localhost:8081/get
curl http://localhost:8081/headers
curl http://localhost:8081/status/200 -i
```

## なぜIngressを最初に使わないのか

Ingressは環境依存が出やすいです。

- Rancher DesktopではTraefikが有効なことが多い
- RKE2ではIngress Controllerが別途必要なことがある
- Harvester / Proxmox VMではLoadBalancerがないこともある

このlight版では、まずServiceとport-forwardだけで成立する構成にしています。
