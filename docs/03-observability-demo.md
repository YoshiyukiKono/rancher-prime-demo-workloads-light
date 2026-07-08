# 03. Observability Demo

このデモワークロードは、Observability製品で以下を観察するために使います。

- Pod CPU / Memory
- Pod restart
- Service / Endpoint
- HTTP traffic
- Logs
- Scale change

## 基本確認

```bash
kubectl get pods -n demo-light -o wide
kubectl top pods -n demo-light
kubectl logs -n demo-light deploy/traffic-generator
kubectl logs -n demo-light deploy/frontend-nginx
kubectl logs -n demo-light deploy/backend-httpbin
```

## traffic-generator

`traffic-generator` は数秒ごとに以下へアクセスします。

- `http://frontend-nginx`
- `http://backend-httpbin:8000/get`
- `http://backend-httpbin:8000/status/200`

これにより、Observability側で継続的なログや通信を確認できます。

## スケール変更

frontendを増やします。

```bash
kubectl -n demo-light scale deploy/frontend-nginx --replicas=2
kubectl get pods -n demo-light -o wide
```

戻します。

```bash
kubectl -n demo-light scale deploy/frontend-nginx --replicas=1
```

Observabilityでは、Pod数の変化や新しいPodの起動を観察できます。

## Pod再作成

```bash
kubectl -n demo-light rollout restart deploy/frontend-nginx
kubectl get pods -n demo-light -w
```

この操作で、Podの入れ替わり、ログ、メトリクスの変化を確認できます。

## Port forward

```bash
kubectl -n demo-light port-forward svc/frontend-nginx 8080:80
curl http://localhost:8080
```

```bash
kubectl -n demo-light port-forward svc/backend-httpbin 8081:8000
curl http://localhost:8081/get
```

## 重要な考え方

Observabilityの目的は、単に「画面が見える」ことではありません。

- 何が動いているか
- どこに通信しているか
- いつ増減したか
- どのPodが重いか
- どのログが出ているか

を継続的に確認できることです。
