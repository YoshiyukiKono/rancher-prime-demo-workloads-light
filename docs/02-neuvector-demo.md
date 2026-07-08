# 02. NeuVector Demo

このデモワークロードは、NeuVectorの以下の特徴を観察するために使います。

- Runtime visibility
- Container / Image scan
- Network visibility
- Process observation
- Zero Trust / policy learning の入口

## 期待する通信

```text
traffic-generator
    ↓
frontend-nginx
    ↓
backend-httpbin
```

さらに、手動で `debug-curl` から通信を発生させます。

```text
debug-curl
    ↓
frontend-nginx

debug-curl
    ↓
backend-httpbin
```

## デプロイ

```bash
./scripts/deploy.sh
```

## 状態確認

```bash
kubectl get pods -n demo-light -o wide
kubectl get svc -n demo-light
```

## 手動通信

```bash
./scripts/generate-manual-traffic.sh
```

または、直接Podに入ります。

```bash
kubectl -n demo-light exec -it deploy/debug-curl -- sh
```

Pod内で:

```sh
curl -s http://frontend-nginx
curl -s http://backend-httpbin:8000/get
curl -s http://backend-httpbin:8000/headers
```

## NeuVector UIで見る場所

Rancher UIからNeuVectorを開き、次を確認します。

- Assets
- Network Activity
- Security Events
- Vulnerabilities
- Containers
- Applications / Groups

## 観察ポイント

### 1. Image Scan

以下のイメージがスキャン対象になります。

- `nginx:1.27-alpine`
- `kennethreitz/httpbin`
- `curlimages/curl:8.11.1`

### 2. Network

`traffic-generator` が定期的に `frontend-nginx` と `backend-httpbin` にアクセスします。

NeuVectorの通信可視化で、Pod間通信が表示されるか確認します。

### 3. Runtime

`debug-curl` に exec して `curl` を実行すると、通常運用とは異なる手動操作として観察できます。

この時点では攻撃デモではなく、Runtimeでプロセスや通信が見えることを確認するのが目的です。

## 注意

このリポジトリでは攻撃ツールや脆弱なアプリケーションを意図的には含めません。最初の目的は、NeuVectorで「見える」ことを確認することです。
