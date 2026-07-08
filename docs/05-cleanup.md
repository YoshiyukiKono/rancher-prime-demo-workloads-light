# 05. Cleanup

デモワークロードを削除するには次を実行します。

```bash
./scripts/cleanup.sh
```

または手動で:

```bash
kubectl delete namespace demo-light
```

削除確認:

```bash
kubectl get ns | grep demo-light || true
```

## 注意

NeuVectorやObservability自体は削除しません。このリポジトリが作るのは `demo-light` namespace 配下のワークロードだけです。
