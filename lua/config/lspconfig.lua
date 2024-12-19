local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

local lsp_attach = function(client, bufnr)
	local opts = { buffer = bufnr }
	client.server_capabilities.documentFormattingProvider = true
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
end

lsp_zero.extend_lspconfig({
	sign_text = true,
	lsp_attach = lsp_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

local server_config = require("lspconfig.configs")
local util = require("lspconfig.util")
server_config.kcl = {
	default_config = {},
}
local lspconfig = require("lspconfig")
lspconfig.on_init = function(client)
	client.offset_encoding = "utf-8"
end
lspconfig.kcl.setup({
	cmd = { "kcl-language-server" },
	filetypes = { "kcl" },
	root_dir = util.root_pattern(".git"),
})
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

-- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
-- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
capabilities.workspace = {
	didChangeWatchedFiles = {
		dynamicRegistration = true,
	},
}

require("fidget").setup()
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"gopls",
		"omnisharp",
	},
	handlers = {
		function(server_name) -- default handler (optional)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end,
		zls = function()
			lspconfig.zls.setup({
				root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
				settings = {
					zls = {
						enable_inlay_hints = true,
						enable_snippets = true,
						warn_style = true,
					},
				},
			})
			vim.g.zig_fmt_parse_errors = 0
			vim.g.zig_fmt_autosave = 0
		end,
		lua_ls = function()
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "Lua 5.1" },
						diagnostics = {
							globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
						},
					},
				},
			})
		end,
		omnisharp = function()
			lspconfig.omnisharp.setup({})
		end,
		golangci_lint_ls = function()
			lspconfig.golangci_lint_ls.setup({
				capabilities = capabilities,
				on_attach = lsp_attach,
				filetypes = { "go" },
			})
		end,
		basedpyright = function()
			lspconfig.basedpyright.setup({})
		end,
		gopls = function()
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = lsp_attach,
				filetypes = { "go" },
				settings = {
					buildFlags = { "-tags=integration,unit,db" },
					gopls = {
						analyses = {
							append = true,
							asmdecl = true,
							assign = true,
							atomic = true,
							unreachable = true,
							nilness = true,
							ST1003 = true,
							undeclaredname = true,
							fillreturns = true,
							nonewvars = true,
							fieldalignment = true,
							shadow = true,
							unusedvariable = true,
							unusedparams = true,
							useany = true,
							unusedwrite = true,
						},
						codelenses = {
							generate = true, -- show the `go generate` lens.
							gc_details = true, -- Show a code lens toggling the display of gc's choices.
							test = true,
							tidy = true,
							vendor = true,
							regenerate_cgo = true,
							upgrade_dependency = true,
						},
						hints = {
							assignVariableTypes = false,
							compositeLiteralFields = false,
							compositeLiteralTypes = false,
							constantValues = true,
							functionTypeParameters = false,
							parameterNames = false,
							rangeVariableTypes = false,
						},
						usePlaceholders = false,
						completeUnimported = true,
						staticcheck = true,
						matcher = "Fuzzy",
						symbolMatcher = "FastFuzzy",
						semanticTokens = false,
						--	noSemanticString = true, -- disable semantic string tokens so we can use treesitter highlight injection
						vulncheck = "Imports",
					},
				},
			})
		end,
		yamlls = function()
			lspconfig.yamlls.setup({
				schemas = {
					kubernetes = "*.yaml",
					["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
					["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
					["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
					["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
					["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
					["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
					["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
					["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
					["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
					["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
					["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
					["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
				},
			})
		end,
		-- pyright = function()
		-- 	lspconfig.pyright.setup({
		-- 		capabilities = capabilities,
		-- 		on_attach = lsp_attach,
		-- 	})
		-- end,
		marksman = function()
			lspconfig.marksman.setup({
				capabilities = capabilities,
				on_attach = lsp_attach,
				filetypes = { "markdown" },
			})
		end,
	},
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{
			name = "nvim_lsp",
		},
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "buffer" },
	}),
})

vim.diagnostic.config({
	-- update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})
