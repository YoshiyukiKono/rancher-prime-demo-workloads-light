# 01. Overview

このリポジトリは、Rancher Prime の各機能を観察するための共通デモワークロードです。

## 設計思想

最初の学習対象は、アプリケーション開発ではありません。

目的は次の3つです。

1. Kubernetes上に複数Podを配置する
2. Pod間通信を発生させる
3. セキュリティ・監視・ポリシー製品が観察できる対象を作る

そのため、この light 版では自作イメージを作りません。

## なぜ公開済みイメージだけにするのか

ローカルビルドしたイメージを Kubernetes が利用できるかどうかは環境依存です。

Rancher Desktop や Docker Desktop では、ローカルの Docker image store と Kubernetes が同じイメージを見られることがあります。一方、Harvester / Proxmox VM / RKE2 / k3s / containerd 環境では、Macでビルドしたイメージはクラスタノードから見えません。

その場合は、通常、次のどれかが必要になります。

- container registry に push する
- 各ノードへ image import する
- kind / k3d のような専用 load 機能を使う

このリポジトリではその複雑さを避け、どの環境でも同じように pull できる公開イメージだけを使います。

## Component

### frontend-nginx

軽量なWebサーバです。

- Image: `nginx:1.27-alpine`
- Port: 80
- Role: 観察しやすいフロントエンド

### backend-httpbin

HTTPリクエストの検証に使いやすいバックエンドです。

- Image: `kennethreitz/httpbin`
- Port: 8000
- Role: `/get`, `/headers`, `/status/200` などを返すHTTPテストサーバ

### traffic-generator

curlを使って定期的に通信を発生させます。

- Image: `curlimages/curl:8.11.1`
- Role: NeuVector / Observability に通信イベントを作る

### debug-curl

手動確認用のPodです。

- Image: `curlimages/curl:8.11.1`
- Role: `kubectl exec` で入り、任意の通信を発生させる

## リポジトリの位置づけ

このリポジトリは、以下のような first-contact シリーズから参照される共通教材です。

```text
rancher-prime-demo-workloads-light
        │
        ├── rancher-prime-neuvector-first-contact
        ├── rancher-prime-observability-first-contact
        └── rancher-prime-admission-controller-first-contact
```
