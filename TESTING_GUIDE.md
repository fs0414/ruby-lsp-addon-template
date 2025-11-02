# Ruby LSP Addon Template - 動作確認ガイド

このアドオンの動作確認方法をエディタ別に説明します。

## 📚 エディタ別ガイド

お使いのエディタに応じて、以下のガイドを参照してください：

### 🎯 Neovim
**[Neovim版動作確認ガイド](TESTING_GUIDE_NEOVIM.md)** を参照

- nvim-lspconfigの設定方法
- lazy.nvim / Packerでのセットアップ
- coc.nvimでの設定
- キーマップ設定（`K`でHover表示）
- LSPログの確認方法
- トラブルシューティング

### 💻 VSCode
**[VSCode版動作確認ガイド](TESTING_GUIDE_VSCODE.md)** を参照

- Ruby LSP拡張機能のインストール
- settings.jsonの設定
- Hoverツールチップの確認方法
- Output パネルでのログ確認
- トラブルシューティング

---

## 🚀 クイックスタート（共通）

### 1. アドオンのインストール

```bash
# リポジトリをクローン
git clone https://github.com/fs0414/ruby-lsp-addon-template.git
cd ruby-lsp-addon-template

# 依存関係をインストール
bundle install

# Gemをビルド＆インストール
gem build ruby_lsp_addon_template.gemspec
gem install ./ruby_lsp_addon_template-0.1.0.gem
```

### 2. テストプロジェクトの作成

```bash
# 新しいディレクトリを作成
mkdir ruby-lsp-test
cd ruby-lsp-test

# Gemfileを作成
cat > Gemfile << 'EOF'
source "https://rubygems.org"
gem "ruby-lsp", "~> 0.22"
gem "ruby_lsp_addon_template"
EOF

# 依存関係をインストール
bundle install

# テスト用のRubyファイルを作成
cat > test.rb << 'EOF'
class MyTestClass
  def greet
    puts "Hello!"
  end
end

module MyTestModule
  def self.hello
    puts "Hello from module!"
  end
end
EOF
```

### 3. エディタで確認

- **Neovim**: `nvim test.rb` を開いて、`MyTestClass` にカーソルを合わせて `K` を押す
- **VSCode**: `code .` でプロジェクトを開いて、`MyTestClass` にマウスホバー

### 4. 期待される結果

以下のようなHover情報が表示されます：

```markdown
**Custom Addon Info**

This is a class definition for `MyTestClass`.

🎉 Hello from Ruby LSP Addon Template!
```

---

## ✅ 動作確認項目

どちらのエディタでも以下を確認してください：

1. ✅ **クラス定義** (`class MyTestClass`) でHover表示
2. ✅ **モジュール定義** (`module MyTestModule`) でHover表示
3. ✅ **メソッド定義** (`def greet`) でHover表示
4. ✅ アドオンの起動メッセージ: "Ruby LSP Addon Template activated!"

---

## 📖 詳細ガイド

- **[Neovim版の詳細ガイド](TESTING_GUIDE_NEOVIM.md)**
  - nvim-lspconfigの詳細設定
  - キーマップのカスタマイズ
  - LSPログのデバッグ方法
  - Telescope.nvim連携

- **[VSCode版の詳細ガイド](TESTING_GUIDE_VSCODE.md)**
  - Ruby LSP拡張機能の設定
  - settings.jsonのカスタマイズ
  - Output パネルの使い方
  - デバッグモードの有効化

---

## 🐛 トラブルシューティング

### 共通の問題

#### 1. Hoverが表示されない

```bash
# Gemがインストールされているか確認
gem list | grep ruby_lsp_addon_template

# プロジェクトのGemfileに含まれているか確認
bundle list | grep ruby_lsp_addon_template
```

#### 2. アドオンが読み込まれない

ファイル構造を確認：
```bash
ls -la lib/ruby_lsp/ruby_lsp_addon_template/addon.rb
```

このファイルが存在しないとRuby LSPが自動検出できません。

#### 3. Ruby LSPが起動しない

```bash
# Ruby LSPのバージョン確認
bundle exec ruby-lsp --version

# 手動で起動テスト
cd /path/to/test-project
bundle exec ruby-lsp
```

---

## 📚 その他のリソース

- [README.md](README.md) - アドオンの概要と使い方
- [PR_DETAILS.md](PR_DETAILS.md) - 実装の詳細

---

## 🆘 サポート

問題が解決しない場合は、以下を確認してください：

1. 使用しているエディタ（Neovim / VSCode）
2. Ruby LSPのバージョン (`bundle exec ruby-lsp --version`)
3. Rubyのバージョン (`ruby -v`)
4. エラーログ（LSPログから抜粋）

[Issues](https://github.com/fs0414/ruby-lsp-addon-template/issues) で質問してください。

Happy coding! 🎉
