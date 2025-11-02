# Ruby LSP Addon Template - 動作確認ガイド

このガイドでは、実装したRuby LSPアドオンの動作を確認する方法を説明します。

## 📋 目次

1. [環境セットアップ](#環境セットアップ)
2. [アドオンのインストール](#アドオンのインストール)
3. [VSCodeでの設定](#vscodeでの設定)
4. [動作確認手順](#動作確認手順)
5. [トラブルシューティング](#トラブルシューティング)

---

## 環境セットアップ

### 前提条件

- Ruby 3.0以上
- Bundler 2.0以上
- VSCode
- Ruby LSP拡張機能

### 1. Ruby LSP拡張機能のインストール

VSCodeで以下の拡張機能をインストールしてください：

```
Name: Ruby LSP
Id: Shopify.ruby-lsp
```

または、VSCodeのExtensions画面で「Ruby LSP」を検索してインストール。

---

## アドオンのインストール

### 方法1: ローカルGemとしてインストール（推奨）

```bash
# 1. リポジトリをクローン
git clone https://github.com/fs0414/ruby-lsp-addon-template.git
cd ruby-lsp-addon-template

# 2. 依存関係をインストール
bundle install

# 3. Gemをビルド
gem build ruby_lsp_addon_template.gemspec

# 4. ローカルにインストール
gem install ./ruby_lsp_addon_template-0.1.0.gem

# 5. インストール確認
gem list | grep ruby_lsp_addon_template
```

### 方法2: Gemfile経由で開発版を使用

テストプロジェクトの`Gemfile`に以下を追加：

```ruby
# Gemfile
gem "ruby-lsp", "~> 0.22"
gem "ruby_lsp_addon_template", path: "/path/to/ruby-lsp-addon-template"
```

```bash
bundle install
```

### 方法3: Gemfileからgitリポジトリを参照

```ruby
# Gemfile
gem "ruby-lsp", "~> 0.22"
gem "ruby_lsp_addon_template", git: "https://github.com/fs0414/ruby-lsp-addon-template.git"
```

```bash
bundle install
```

---

## VSCodeでの設定

### 1. テストプロジェクトを作成

```bash
# テスト用のRubyプロジェクトを作成
mkdir ruby-lsp-test
cd ruby-lsp-test

# Gemfileを作成
cat > Gemfile << 'EOF'
source "https://rubygems.org"

gem "ruby-lsp", "~> 0.22"
gem "ruby_lsp_addon_template", path: "/path/to/ruby-lsp-addon-template"
EOF

# 依存関係をインストール
bundle install

# テスト用のRubyファイルを作成
cat > test.rb << 'EOF'
# frozen_string_literal: true

# このクラスにカーソルを合わせてください
class MyTestClass
  def initialize
    @name = "test"
  end

  # このメソッドにカーソルを合わせてください
  def greet
    puts "Hello, #{@name}!"
  end
end

# このモジュールにカーソルを合わせてください
module MyTestModule
  def self.hello
    puts "Hello from module!"
  end
end

# テスト実行
obj = MyTestClass.new
obj.greet
MyTestModule.hello
EOF
```

### 2. VSCodeでプロジェクトを開く

```bash
code .
```

### 3. Ruby LSPを起動

1. VSCodeでコマンドパレットを開く（`Cmd/Ctrl + Shift + P`）
2. "Ruby LSP: Restart" を実行
3. Output パネルで "Ruby LSP" チャンネルを選択してログを確認

### 4. アドオンが読み込まれたか確認

Output パネルのRuby LSPログに以下のメッセージが表示されるはずです：

```
Ruby LSP Addon Template activated!
```

---

## 動作確認手順

### ✅ テスト1: クラス定義でのHover

1. `test.rb` を開く
2. `class MyTestClass` の `MyTestClass` にカーソルを合わせる
3. Hoverツールチップが表示されることを確認
4. 以下のメッセージが含まれていることを確認：

```markdown
**Custom Addon Info**

This is a class definition for `MyTestClass`.

🎉 Hello from Ruby LSP Addon Template!
```

### ✅ テスト2: モジュール定義でのHover

1. `module MyTestModule` の `MyTestModule` にカーソルを合わせる
2. 以下のメッセージが表示されることを確認：

```markdown
**Custom Addon Info**

This is a module definition for `MyTestModule`.

🎉 Hello from Ruby LSP Addon Template!
```

### ✅ テスト3: メソッド定義でのHover

1. `def greet` の `greet` にカーソルを合わせる
2. 以下のメッセージが表示されることを確認：

```markdown
**Custom Addon Info**

This is a method definition for `greet`.

🎉 Hello from Ruby LSP Addon Template!
```

### 📸 スクリーンショット例

Hoverツールチップは以下のように表示されます：

```
┌─────────────────────────────────────────────┐
│ **Custom Addon Info**                       │
│                                             │
│ This is a class definition for `MyTestClass`│
│                                             │
│ 🎉 Hello from Ruby LSP Addon Template!      │
└─────────────────────────────────────────────┘
```

---

## トラブルシューティング

### 問題1: Hoverが表示されない

**確認事項:**

1. **Ruby LSPが起動しているか確認**
   ```
   VSCode Output > Ruby LSP
   ```

2. **アドオンが読み込まれているか確認**

   ログに "Ruby LSP Addon Template activated!" が表示されているか確認

3. **Gemがインストールされているか確認**
   ```bash
   bundle list | grep ruby_lsp_addon_template
   ```

4. **Ruby LSPを再起動**

   コマンドパレット → "Ruby LSP: Restart"

### 問題2: "Ruby LSP Addon Template activated!" が表示されない

**原因:** アドオンが自動検出されていない

**解決策:**

1. **ファイル配置を確認**
   ```
   lib/ruby_lsp/ruby_lsp_addon_template/addon.rb
   ```
   このパスに`addon.rb`が存在する必要があります。

2. **Gemがバンドルに含まれているか確認**
   ```bash
   bundle exec ruby -e "require 'ruby_lsp_addon_template'; puts 'OK'"
   ```

3. **require順序を確認**

   `lib/ruby_lsp_addon_template.rb`で以下の順序で読み込んでいるか確認：
   ```ruby
   require "ruby_lsp/addon"
   require_relative "ruby_lsp_addon_template/hover"
   require_relative "ruby_lsp/ruby_lsp_addon_template/addon"
   ```

### 問題3: エラーが表示される

**Ruby LSPログを確認:**

```
VSCode Output > Ruby LSP
```

よくあるエラー：

1. **LoadError: cannot load such file**

   → 依存関係が不足している。`bundle install`を実行。

2. **NameError: uninitialized constant**

   → モジュール/クラスの名前が一致していない。gem名とモジュール名を確認。

3. **ArgumentError: wrong number of arguments**

   → Ruby LSP APIのバージョン不一致。`Gemfile.lock`を削除して`bundle install`。

### 問題4: VSCodeでHoverが表示されるが、カスタム情報が含まれない

**確認事項:**

1. **複数のHover情報が統合されている**

   Ruby LSP標準のHover情報とアドオンの情報が統合されて表示されます。
   スクロールして「Custom Addon Info」セクションを探してください。

2. **ノードタイプが一致しているか確認**

   現在のアドオンは以下のノードタイプのみサポート：
   - クラス定義 (class)
   - モジュール定義 (module)
   - メソッド定義 (def)

---

## デバッグモード

より詳細なログを確認したい場合：

### 1. デバッグログを有効化

VSCodeの設定（`settings.json`）に追加：

```json
{
  "rubyLsp.enableExperimentalFeatures": true,
  "rubyLsp.trace.server": "verbose"
}
```

### 2. Ruby LSPを再起動

コマンドパレット → "Ruby LSP: Restart"

### 3. ログを確認

Output パネル → "Ruby LSP" チャンネル

---

## 高度な動作確認

### カスタムHover情報のテスト

以下のような複雑なコードでも動作確認できます：

```ruby
# ネストしたクラス
class Outer
  class Inner
    def method_in_inner
      # このメソッドにカーソルを合わせる
    end
  end
end

# 継承したクラス
class Child < Parent
  # "Child" にカーソルを合わせる
end

# モジュールのinclude
module Mixin
  def mixin_method
    # "mixin_method" にカーソルを合わせる
  end
end

class WithMixin
  include Mixin
end
```

---

## 次のステップ

動作確認が成功したら：

1. ✅ カスタムHover情報の内容を変更してみる
2. ✅ 他のLSP機能（Definition, Completionなど）を追加してみる
3. ✅ 他のノードタイプ（定数、変数など）のサポートを追加してみる

詳細は [README.md](README.md) を参照してください。

---

## サポート

問題が解決しない場合：

1. [Issues](https://github.com/fs0414/ruby-lsp-addon-template/issues) で既存の問題を検索
2. 新しいIssueを作成（再現手順とログを含める）
3. [Ruby LSP公式ドキュメント](https://shopify.github.io/ruby-lsp/) を参照

Happy coding! 🚀
