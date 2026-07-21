# rancher-prime-demo-workloads-light

公開済みコンテナイメージだけで構成する、Rancher Prime 学習用の軽量デモワークロードです。

このリポジトリは、NeuVector / Observability / Admission Controller などを学ぶときに、毎回同じ観察対象を用意するためのものです。自作アプリのビルド、GHCR、multi-arch image、imagePullSecret などは扱いません。まずは Kubernetes 上に「見える・通信する・ログが出る・スキャンできる」対象を置くことを優先します。

## 目的

- Mac の Rancher Desktop でも動く
- Harvester / Proxmox VM 上の k3s / RKE2 / Kubernetes でも動く
- Docker engine / containerd の違いに依存しない
- NeuVector で通信・コンテナ・イメージを観察できる
- Observability で Pod / Service / Traffic / Logs を観察できる
- Admission Controller のポリシーテスト対象としても使える

## 構成

```text
Namespace: demo-light

traffic-generator
    ↓ HTTP
frontend-nginx
    ↓ HTTP
backend-httpbin

debug-curl
    手動検証用Pod
```

使うイメージは公開済みのものだけです。

| Component | Image | Role |
|---|---|---|
| frontend-nginx | `nginx:1.27-alpine` | 軽量Webサーバ |
| backend-httpbin | `kennethreitz/httpbin` | HTTPテスト用バックエンド |
| traffic-generator | `curlimages/curl:8.11.1` | 定期HTTPアクセス |
| debug-curl | `curlimages/curl:8.11.1` | 手動通信確認 |

## すぐに使う

```bash
./scripts/deploy.sh
./scripts/status.sh
```

疎通確認:

```bash
kubectl -n demo-light port-forward svc/frontend-nginx 8080:80
curl http://localhost:8080
```

バックエンド確認:

```bash
kubectl -n demo-light port-forward svc/backend-httpbin 8081:8000
curl http://localhost:8081/get
```

手動トラフィック:

```bash
./scripts/generate-manual-traffic.sh
```

削除:

```bash
./scripts/cleanup.sh
```

## なぜ light 版なのか

ローカルで `docker build` したイメージを Kubernetes からそのまま利用できるかどうかは、Rancher Desktop / Docker Desktop / k3s / RKE2 / containerd / Docker engine の構成に依存します。

この light 版ではその曖昧さを避けます。すべて公開済みイメージを使うため、Harvester / Proxmox VM / SLES / Ubuntu / Rancher Desktop などに移しても、基本的には同じ手順で動作します。

## NeuVectorで見るポイント

- `demo-light` namespace のPod一覧
- `traffic-generator → frontend-nginx` の通信
- `frontend-nginx → backend-httpbin` の通信
- `debug-curl` からの手動通信
- nginx / httpbin / curlimages のイメージスキャン
- Runtime中のプロセス・ネットワーク挙動

詳細は [docs/02-neuvector-demo.md](docs/02-neuvector-demo.md) を参照してください。

## Observabilityで見るポイント

- Pod CPU / Memory
- Service / Pod の稼働状況
- traffic-generator による継続的なHTTPアクセス
- nginx / httpbin のログ
- スケール変更やPod再作成時の変化

詳細は [docs/03-observability-demo.md](docs/03-observability-demo.md) を参照してください。

## baseline snapshot

現在状態を記録する場合:

```bash
./history/baseline/snapshot.sh
```

出力は `history/baseline/outputs/` に保存されます。

## 確認環境

- Mac
- Rancher Desktop
- k3s

Kubernetesクラスタからインターネット上の公開コンテナレジストリへアクセスできる必要があります。
