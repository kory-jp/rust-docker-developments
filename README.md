# Rust学習用環境

## 参考サイト

[参考サイト](https://qiita.com/RutoArca/items/b81b06202778999756bb)

## 起動

vscodeの設定を反映させるために `.vscode/launch.json` ファイルの `project` 部分を今回、 `cargo new` で作成するプロジェクト名で置換をする。

ローカルにてコンテナ起動

```
docker compose up -d
```

コンテナ内にログイン

workspaceへ移動

```
cd /workspace
```

新プロジェクト作成

```
cargo new project
```

hello world

```
cd project
cargo run
```
