# 06. Runtime and Image Notes

## ローカルビルドイメージの注意点

Mac上で `docker build` したイメージを、Kubernetesがそのまま利用できるかどうかは環境に依存します。

### 利用できることがある環境

- Docker Desktop
- Rancher Desktop with Docker engine / Moby
- kind / k3d のように明示的な image load 機能を持つ環境

### そのままでは利用できないことが多い環境

- Harvester上のVM
- Proxmox上のVM
- RKE2
- k3s with containerd
- 複数ノードクラスタ

これらの環境では、通常、イメージをRegistryへpushする必要があります。

## このリポジトリの方針

このlight版は、ローカルビルドに依存しません。

```text
公開済みイメージのみ利用
↓
どのKubernetesでもpull可能
↓
NeuVector / Observability の観察対象として使いやすい
```

## imagePullPolicy

このリポジトリでは `IfNotPresent` を基本にしています。

`Never` はローカルビルド専用になりやすく、移植性が落ちます。
