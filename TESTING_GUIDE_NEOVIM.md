# Ruby LSP Addon Template - 動作確認ガイド (Neovim版)

このガイドでは、Neovimを使用してRuby LSPアドオンの動作を確認する方法を説明します。

## 📋 目次

1. [環境セットアップ](#環境セットアップ)
2. [アドオンのインストール](#アドオンのインストール)
3. [Neovimの設定](#neovimの設定)
4. [動作確認手順](#動作確認手順)
5. [トラブルシューティング](#トラブルシューティング)

---

## 環境セットアップ

### 前提条件

- Ruby 3.0以上
- Bundler 2.0以上
- Neovim 0.9以上
- LSP設定済みのNeovim環境

### 1. Neovim LSP環境の確認

以下のいずれかのLSPクライアントが設定されていることを確認：

- **nvim-lspconfig** (推奨)
- **coc.nvim**
- **vim-lsp**

本ガイドでは **nvim-lspconfig** を使用した例を示します。

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

### 方法2: プロジェクトのGemfile経由（開発用）

テストプロジェクトの`Gemfile`に以下を追加：

```ruby
# Gemfile
source "https://rubygems.org"

gem "ruby-lsp", "~> 0.22"
gem "ruby_lsp_addon_template", path: "/path/to/ruby-lsp-addon-template"
```

```bash
bundle install
```

---

## Neovimの設定

### 設定例1: nvim-lspconfig + lazy.nvim

#### 1. Ruby LSPプラグインのインストール

`~/.config/nvim/lua/plugins/lsp.lua`:

```lua
return {
  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "ruby_lsp" },
      })
    end,
  },
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Ruby LSP setup
      lspconfig.ruby_lsp.setup({
        cmd = { "bundle", "exec", "ruby-lsp" },
        filetypes = { "ruby" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        init_options = {
          formatter = "auto",
        },
        on_attach = function(client, bufnr)
          -- キーマップ設定
          local opts = { buffer = bufnr, noremap = true, silent = true }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          print("Ruby LSP attached to buffer " .. bufnr)
        end,
      })
    end,
  },
}
```

#### 2. Hoverウィンドウの設定（オプション）

`~/.config/nvim/lua/config/lsp.lua`:

```lua
-- Hover設定
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    max_width = 80,
    max_height = 30,
  }
)

-- 診断表示の設定
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})
```

### 設定例2: シンプルなnvim-lspconfig設定

`~/.config/nvim/init.lua`に直接追加：

```lua
-- nvim-lspconfigのインストール（Packer使用の例）
require('packer').startup(function(use)
  use 'neovim/nvim-lspconfig'
end)

-- Ruby LSP設定
local lspconfig = require('lspconfig')

lspconfig.ruby_lsp.setup({
  cmd = { "bundle", "exec", "ruby-lsp" },
  filetypes = { "ruby" },
  root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
  on_attach = function(client, bufnr)
    -- Hover表示: K キー
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    print("Ruby LSP started!")
  end,
})
```

### 設定例3: coc.nvim

`~/.config/nvim/coc-settings.json`:

```json
{
  "languageserver": {
    "ruby": {
      "command": "bundle",
      "args": ["exec", "ruby-lsp"],
      "filetypes": ["ruby"],
      "rootPatterns": ["Gemfile", ".git"],
      "initializationOptions": {}
    }
  }
}
```

---

## テストプロジェクトのセットアップ

### 1. プロジェクト作成

```bash
# テスト用のRubyプロジェクトを作成
mkdir ruby-lsp-test
cd ruby-lsp-test

# Gemfileを作成
cat > Gemfile << 'EOF'
source "https://rubygems.org"

gem "ruby-lsp", "~> 0.22"
gem "ruby_lsp_addon_template"  # グローバルインストール済みの場合
# または
# gem "ruby_lsp_addon_template", path: "/path/to/ruby-lsp-addon-template"
EOF

# 依存関係をインストール
bundle install
```

### 2. テスト用Rubyファイルを作成

```bash
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

  # このメソッドにもカーソルを合わせてください
  def farewell
    puts "Goodbye!"
  end
end

# このモジュールにカーソルを合わせてください
module MyTestModule
  def self.hello
    puts "Hello from module!"
  end

  def self.version
    "1.0.0"
  end
end

# ネストしたクラスのテスト
class Outer
  class Inner
    def inner_method
      "I'm inside!"
    end
  end
end

# テスト実行
obj = MyTestClass.new
obj.greet
obj.farewell
MyTestModule.hello
EOF
```

### 3. Neovimで開く

```bash
nvim test.rb
```

---

## 動作確認手順

### ステップ1: LSPの起動確認

1. Neovimで`test.rb`を開く
2. LSPが起動したことを確認（`:LspInfo`で確認）

```vim
:LspInfo
```

以下のような出力が表示されるはずです：

```
Language client log: /home/user/.local/state/nvim/lsp.log
Detected filetype:   ruby

1 client(s) attached to this buffer:
  Client: ruby_lsp (id: 1, bufnr: [1])
    filetypes:       ruby
    autostart:       true
    root directory:  /path/to/ruby-lsp-test
    cmd:             bundle exec ruby-lsp
```

### ステップ2: Ruby LSPログの確認

```bash
# 別のターミナルでログを確認
tail -f ~/.local/state/nvim/lsp.log
```

以下のメッセージが含まれているはずです：

```
Ruby LSP Addon Template activated!
```

### ✅ テスト1: クラス定義でのHover

1. `class MyTestClass` の行にカーソルを移動
2. `MyTestClass` の上で `K` キーを押す（Normal mode）
3. Hoverウィンドウが表示される
4. 以下の内容が含まれていることを確認：

```markdown
**Custom Addon Info**

This is a class definition for `MyTestClass`.

🎉 Hello from Ruby LSP Addon Template!
```

### ✅ テスト2: モジュール定義でのHover

1. `module MyTestModule` の行にカーソルを移動
2. `MyTestModule` の上で `K` キーを押す
3. 以下の内容が表示されることを確認：

```markdown
**Custom Addon Info**

This is a module definition for `MyTestModule`.

🎉 Hello from Ruby LSP Addon Template!
```

### ✅ テスト3: メソッド定義でのHover

1. `def greet` の行にカーソルを移動
2. `greet` の上で `K` キーを押す
3. 以下の内容が表示されることを確認：

```markdown
**Custom Addon Info**

This is a method definition for `greet`.

🎉 Hello from Ruby LSP Addon Template!
```

### 📸 Hoverウィンドウの例

Neovimでは以下のようなフローティングウィンドウが表示されます：

```
╭───────────────────────────────────────────╮
│ **Custom Addon Info**                     │
│                                           │
│ This is a class definition for            │
│ `MyTestClass`.                            │
│                                           │
│ 🎉 Hello from Ruby LSP Addon Template!    │
╰───────────────────────────────────────────╯
```

---

## 便利なキーマップ設定

### 推奨キーマップ

`~/.config/nvim/lua/config/keymaps.lua`:

```lua
-- LSP関連のキーマップ
local opts = { noremap = true, silent = true }

-- グローバルキーマップ
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- バッファにLSPがアタッチされた時のキーマップ
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- Hover情報表示
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

  -- 定義ジャンプ
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)

  -- 実装ジャンプ
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)

  -- 型情報
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

  -- リファレンス検索
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

  -- リネーム
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)

  -- コードアクション
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)

  -- フォーマット
  vim.keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
end
```

---

## トラブルシューティング

### 問題1: Hoverが表示されない

**確認事項:**

1. **LSPが起動しているか確認**
   ```vim
   :LspInfo
   ```

2. **LSPログを確認**
   ```bash
   tail -f ~/.local/state/nvim/lsp.log
   # または
   tail -f ~/.cache/nvim/lsp.log
   ```

3. **アドオンが読み込まれているか確認**

   ログに "Ruby LSP Addon Template activated!" が表示されているか確認

4. **Gemがインストールされているか確認**
   ```bash
   bundle list | grep ruby_lsp_addon_template
   ```

5. **LSPを再起動**
   ```vim
   :LspRestart
   ```

### 問題2: LSPが起動しない

**解決策:**

1. **ruby-lspコマンドが実行できるか確認**
   ```bash
   cd /path/to/ruby-lsp-test
   bundle exec ruby-lsp --version
   ```

2. **Gemfileの確認**
   ```ruby
   # Gemfile
   gem "ruby-lsp", "~> 0.22"
   gem "ruby_lsp_addon_template"
   ```

3. **バンドルインストール**
   ```bash
   bundle install
   ```

4. **Neovim設定の確認**
   ```lua
   -- ruby_lsp.setupが正しく設定されているか確認
   require("lspconfig").ruby_lsp.setup({
     cmd = { "bundle", "exec", "ruby-lsp" },  -- これが重要！
   })
   ```

### 問題3: "Ruby LSP Addon Template activated!" が表示されない

**原因:** アドオンが自動検出されていない

**解決策:**

1. **ファイル配置を確認**
   ```bash
   ls -la lib/ruby_lsp/ruby_lsp_addon_template/addon.rb
   ```
   このファイルが存在する必要があります。

2. **Gemが正しくインストールされているか確認**
   ```bash
   gem list ruby_lsp_addon_template
   # または
   bundle exec gem list ruby_lsp_addon_template
   ```

3. **requireパスの確認**
   ```bash
   bundle exec ruby -e "require 'ruby_lsp_addon_template'; puts 'OK'"
   ```

### 問題4: Hoverウィンドウが小さすぎる/見づらい

**解決策:**

Hover設定をカスタマイズ：

```lua
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",      -- "single", "double", "rounded", "solid", "shadow"
    max_width = 100,         -- 最大幅を調整
    max_height = 40,         -- 最大高さを調整
    focusable = true,        -- フォーカス可能にする
  }
)
```

### 問題5: エラーが表示される

**LSPログの確認:**

```bash
# Neovimのログディレクトリを確認
:echo stdpath('log')

# ログを表示
tail -f ~/.local/state/nvim/lsp.log
```

よくあるエラー：

1. **`bundle: command not found`**

   → Bundlerがインストールされていない
   ```bash
   gem install bundler
   ```

2. **`LoadError: cannot load such file -- ruby_lsp_addon_template`**

   → Gemがインストールされていない
   ```bash
   gem install ruby_lsp_addon_template
   # または
   bundle install
   ```

3. **`LSP[ruby_lsp] exited with code 1`**

   → ruby-lspの設定が間違っている。cmdパスを確認。

---

## デバッグモード

### 1. LSPログレベルを上げる

```lua
vim.lsp.set_log_level("debug")  -- init.luaに追加
```

### 2. ログファイルを確認

```vim
:lua print(vim.lsp.get_log_path())
```

### 3. リアルタイムログ監視

```bash
tail -f $(nvim --headless -c 'lua print(vim.lsp.get_log_path())' -c 'q' 2>&1 | tail -1)
```

### 4. LSP通信の詳細確認

```lua
-- init.luaに追加
require('vim.lsp.log').set_format_func(vim.inspect)
```

---

## 高度な動作確認

### 1. 複雑なコードでのテスト

```ruby
# nested_test.rb
class Outer
  class Inner
    def method_in_inner
      # このメソッドにカーソルを合わせる
      puts "Inner method"
    end
  end

  def outer_method
    # このメソッドにカーソルを合わせる
    Inner.new.method_in_inner
  end
end

module Utilities
  module Helpers
    def helper_method
      # このメソッドにカーソルを合わせる
      "I'm a helper"
    end
  end
end
```

### 2. マルチファイルプロジェクト

```bash
# プロジェクト構造
project/
├── Gemfile
├── lib/
│   ├── models/
│   │   ├── user.rb
│   │   └── post.rb
│   └── services/
│       └── user_service.rb
└── spec/
    └── models/
        └── user_spec.rb
```

各ファイルでHoverが動作することを確認。

---

## 便利なコマンド

### LSP情報確認コマンド

```vim
" LSP接続情報
:LspInfo

" LSPを再起動
:LspRestart

" LSP停止
:LspStop

" 診断情報を表示
:lua vim.diagnostic.open_float()

" すべてのクライアント情報
:lua print(vim.inspect(vim.lsp.get_active_clients()))
```

### Lua関数で確認

```vim
" アドオンが読み込まれているか確認
:lua print(package.loaded['ruby_lsp_addon_template'])

" LSPクライアントの状態
:lua print(vim.inspect(vim.lsp.buf_get_clients()))
```

---

## 次のステップ

動作確認が成功したら：

1. ✅ カスタムHover情報の内容を変更してみる
2. ✅ 他のLSP機能（Definition, Completionなど）を追加してみる
3. ✅ 他のノードタイプ（定数、変数など）のサポートを追加してみる
4. ✅ telescope.nvimと連携させる

### Telescope.nvim連携例

```lua
-- LSPと連携したTelescope設定
local builtin = require('telescope.builtin')

vim.keymap.set('n', 'gr', builtin.lsp_references, {})
vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})
vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, {})
```

---

## 参考リソース

### Neovim LSP関連
- [nvim-lspconfig公式](https://github.com/neovim/nvim-lspconfig)
- [Neovim LSP ドキュメント](https://neovim.io/doc/user/lsp.html)
- [Ruby LSP gem](https://github.com/Shopify/ruby-lsp)

### その他
- [本アドオンのREADME](README.md)
- [Ruby LSP公式ドキュメント](https://shopify.github.io/ruby-lsp/)

---

## サポート

問題が解決しない場合：

1. [Issues](https://github.com/fs0414/ruby-lsp-addon-template/issues) で既存の問題を検索
2. 新しいIssueを作成（Neovim設定とログを含める）
3. LSPログファイルを添付

Happy Vimming! 🚀
