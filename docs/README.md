# launch.json の解説

## 概要

`launch.json` は VS Code のデバッガ設定ファイルです。このファイルは Rust プロジェクトを CodeLLDB を使用してデバッグするための設定を定義しています。

## ファイル構成

```json
{
  "version": "0.2.0",
  "configurations": [...]
}
```

- **version**: デバッグ設定ファイルのバージョン。常に `"0.2.0"` です
- **configurations**: デバッグ設定の配列。複数の設定を定義できます

## 設定の詳細

### 基本的な設定

```json
"type": "lldb",
"request": "launch",
"name": "Debug executable rust-lesson",
```

- **type**: デバッガの種類。`"lldb"` は LLVM Debugger を指定します
- **request**: デバッグの方式。`"launch"` は新しいプロセスを起動してデバッグします
- **name**: VS Code の UI に表示される設定の名前です

### cargo セクション

```json
"cargo": {
  "args": [
    "build",
    "--bin=rust-lesson",
    "--package=rust-lesson"
  ],
  "filter": {
    "name": "rust-lesson",
    "kind": "bin"
  },
  "cwd": "${workspaceFolder}/rust-lesson"
}
```

#### cargo.args

デバッグ前に実行される cargo コマンドの引数を定義します。

- `"build"`: Rust プロジェクトをビルドします
- `"--bin=rust-lesson"`: `rust-lesson` という名前のバイナリをビルド対象にします
- `"--package=rust-lesson"`: `rust-lesson` パッケージをビルド対象にします

#### cargo.filter

ビルド結果からデバッグ対象の実行ファイルをフィルタリングします。

- `"name": "rust-lesson"`: 実行ファイルの名前が `rust-lesson` に一致する
- `"kind": "bin"`: バイナリファイル（実行可能ファイル）を対象にします

#### cargo.cwd（重要な修正点）

```json
"cwd": "${workspaceFolder}/rust-lesson"
```

**このパラメータは問題解決のために追加されました。**

### 問題の原因と解決

#### 問題

最初のエラーメッセージ：

```
error: could not find `Cargo.toml` in `/workspace` or any parent directory
```

このエラーは、cargo コマンドが `/workspace` ディレクトリで実行されていたため、`Cargo.toml` を見つけられませんでした。

ワークスペース構造：

```
/workspace/
  ├── .vscode/
  │   └── launch.json
  ├── Dockerfile
  ├── README.md
  ├── docker-compose.yml
  └── rust-lesson/          ← Cargo.toml はここ
      ├── Cargo.toml
      ├── src/
      └── target/
```

#### 解決策

`cargo` セクションに `cwd` パラメータを追加することで、cargo コマンドを実行するワーキングディレクトリを明示的に指定しました。

- **${workspaceFolder}**: VS Code で開いているワークスペースのルートパス（/workspace）
- **${workspaceFolder}/rust-lesson**: Rust プロジェクトのルートパス（/workspace/rust-lesson）

これにより、cargo は `/workspace/rust-lesson/` ディレクトリで実行され、正しく `Cargo.toml` を見つけられるようになりました。

## 修正前後の比較

### 修正前

```json
"cargo": {
  "args": [
    "build",
    "--bin=rust-lesson",
    "--package=rust-lesson"
  ],
  "filter": {
    "name": "rust-lesson",
    "kind": "bin"
  }
}
```

cargo セクション内にワーキングディレクトリの指定がなく、デフォルトでワークスペースのルート（/workspace）で実行されていました。

### 修正後

```json
"cargo": {
  "args": [
    "build",
    "--bin=rust-lesson",
    "--package=rust-lesson"
  ],
  "filter": {
    "name": "rust-lesson",
    "kind": "bin"
  },
  "cwd": "${workspaceFolder}/rust-lesson"
}
```

`"cwd": "${workspaceFolder}/rust-lesson"` を追加して、正しいディレクトリを指定しました。

## その他の設定

```json
"args": [],
"cwd": "${workspaceFolder}/rust-lesson"
```

- **args**: デバッグ対象のプログラムに渡すコマンドライン引数（空の場合は引数なし）
- **cwd**: デバッグされるプログラムのワーキングディレクトリ

## トラブルシューティング

### エラー: `could not find Cargo.toml`

**原因**: cargo が実行されるディレクトリが `Cargo.toml` の位置と異なっている

**解決策**: `cargo` セクション内に `"cwd"` パラメータを追加し、正しいディレクトリを指定してください

### その他の設定例

マルチプロジェクトの場合、複数の設定を `configurations` 配列に追加できます：

```json
"configurations": [
  {
    "type": "lldb",
    "request": "launch",
    "name": "Debug executable rust-lesson",
    ...
  },
  {
    "type": "lldb",
    "request": "launch",
    "name": "Debug tests",
    "cargo": {
      "args": ["test", "--no-run", "--package=rust-lesson"],
      ...
    }
  }
]
```

## まとめ

この `launch.json` の修正により、VS Code のデバッガが正しく Rust プロジェクトを認識し、デバッグを実行できるようになりました。重要なポイントは、`cargo.cwd` パラメータで実行ディレクトリを明示的に指定することです。
