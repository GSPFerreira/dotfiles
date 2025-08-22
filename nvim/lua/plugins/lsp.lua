return {
	{
		"seblyng/roslyn.nvim",
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {
			-- your configuration comes here; leave empty for default settings
		},
	},
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
			local lspconfig = require("lspconfig")
			lspconfig.on_init = function(client)
				client.offset_encoding = "utf-8"
			end
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kuala-lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- Find references for the word under your cursor.
					map("<leader>rr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("<leader>ri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("<leader>rd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("<leader>rD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>O", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>W",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"Open Workspace Symbols"
					)

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>rt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup = vim.api.nvim_create_augroup("kuala-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kuala-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kuala-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},
				--

				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					-- settings = {
					-- 	Lua = {
					-- 		completion = {
					-- 			callSnippet = "Replace",
					-- 		},
					-- 		-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- 		-- diagnostics = { disable = { 'missing-fields' } },
					-- 	},
					-- },
				},

				zls = {
					settings = {
						zls = {
							enable_inlay_hints = true,
							enable_snippets = true,
							warn_style = true,
						},
					},
				},

				gopls = {
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
				},

				roslyn = {},

				golangci_lint_ls = {},

				basedpyright = {},

				yamlls = {
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
				},

				marksman = {},
				kcl = {
					cmd = { "kcl-language-server" },
				},
			}

			-- Ensure the servers and tools above are installed
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"dockerls",
				"denols",
				"cmake",
				"buf_ls",
				"bicep",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
-- -- local cmp = require("cmp")
-- -- local cmp_lsp = require("cmp_nvim_lsp")
-- -- local capabilities =
-- -- 	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
--
-- -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
-- -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
-- capabilities.workspace = {
-- 	didChangeWatchedFiles = {
-- 		dynamicRegistration = true,
-- 	},
-- },
-- },
-- },

-- require("fidget").setup()
-- require("mason").setup()
-- require("mason-lspconfig").setup({
-- 	ensure_installed = {
-- 		"lua_ls",
-- 		"gopls",
-- 		"csharp_ls",
-- 		"omnisharp",
-- 		"yamlls",
-- 		"zls",
-- 		"marksman",
-- 		"kcl",
-- 		"dockerls",
-- 		"denols",
-- 		"cmake",
-- 		"buf_ls",
-- 		"bicep",
-- 	},
-- 	handlers = {
-- 		function(server_name) -- default handler (optional)
-- 			require("lspconfig")[server_name].setup({
-- 				capabilities = capabilities,
-- 			})
-- 		end,
-- 		zls = function()
-- 			lspconfig.zls.setup({
-- 				root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
-- 				settings = {
-- 					zls = {
-- 						enable_inlay_hints = true,
-- 						enable_snippets = true,
-- 						warn_style = true,
-- 					},
-- 				},
-- 			})
-- 			vim.g.zig_fmt_parse_errors = 0
-- 			vim.g.zig_fmt_autosave = 0
-- 		end,
-- 		lua_ls = function()
-- 			lspconfig.lua_ls.setup({
-- 				capabilities = capabilities,
-- 				settings = {
-- 					Lua = {
-- 						runtime = { version = "Lua 5.1" },
-- 						diagnostics = {
-- 							globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
-- 						},
-- 					},
-- 				},
-- 			})
-- 		end,
-- 		omnisharp = function()
-- 			lspconfig.omnisharp.setup({})
-- 		end,
-- 		golangci_lint_ls = function()
-- 			lspconfig.golangci_lint_ls.setup({
-- 				capabilities = capabilities,
-- 				on_attach = lsp_attach,
-- 				filetypes = { "go" },
-- 			})
-- 		end,
-- 		basedpyright = function()
-- 			lspconfig.basedpyright.setup({})
-- 		end,
-- 		gopls = function()
-- 			lspconfig.gopls.setup({
-- 				capabilities = capabilities,
-- 				on_attach = lsp_attach,
-- 				filetypes = { "go" },
-- 				settings = {
-- 					buildFlags = { "-tags=integration,unit,db" },
-- 					gopls = {
-- 						analyses = {
-- 							append = true,
-- 							asmdecl = true,
-- 							assign = true,
-- 							atomic = true,
-- 							unreachable = true,
-- 							nilness = true,
-- 							ST1003 = true,
-- 							undeclaredname = true,
-- 							fillreturns = true,
-- 							nonewvars = true,
-- 							fieldalignment = true,
-- 							shadow = true,
-- 							unusedvariable = true,
-- 							unusedparams = true,
-- 							useany = true,
-- 							unusedwrite = true,
-- 						},
-- 						codelenses = {
-- 							generate = true, -- show the `go generate` lens.
-- 							gc_details = true, -- Show a code lens toggling the display of gc's choices.
-- 							test = true,
-- 							tidy = true,
-- 							vendor = true,
-- 							regenerate_cgo = true,
-- 							upgrade_dependency = true,
-- 						},
-- 						hints = {
-- 							assignVariableTypes = false,
-- 							compositeLiteralFields = false,
-- 							compositeLiteralTypes = false,
-- 							constantValues = true,
-- 							functionTypeParameters = false,
-- 							parameterNames = false,
-- 							rangeVariableTypes = false,
-- 						},
-- 						usePlaceholders = false,
-- 						completeUnimported = true,
-- 						staticcheck = true,
-- 						matcher = "Fuzzy",
-- 						symbolMatcher = "FastFuzzy",
-- 						semanticTokens = false,
-- 						--	noSemanticString = true, -- disable semantic string tokens so we can use treesitter highlight injection
-- 						vulncheck = "Imports",
-- 					},
-- 				},
-- 			})
-- 		end,
-- 		yamlls = function()
-- 			lspconfig.yamlls.setup({
-- 				schemas = {
-- 					kubernetes = "*.yaml",
-- 					["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
-- 					["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
-- 					["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
-- 					["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
-- 					["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
-- 					["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
-- 					["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
-- 					["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
-- 					["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
-- 					["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
-- 					["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
-- 					["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
-- 				},
-- 			})
-- 		end,
-- 		-- pyright = function()
-- 		-- 	lspconfig.pyright.setup({
-- 		-- 		capabilities = capabilities,
-- 		-- 		on_attach = lsp_attach,
-- 		-- 	})
-- 		-- end,
-- 		marksman = function()
-- 			lspconfig.marksman.setup({
-- 				capabilities = capabilities,
-- 				on_attach = lsp_attach,
-- 				filetypes = { "markdown" },
-- 			})
-- 		end,
-- 		kcl = function()
-- 			lspconfig.kcl.setup({
-- 				cmd = { "kcl-language-server" },
-- 				filetypes = { "kcl" },
-- 				root_dir = util.root_pattern(".git"),
-- 			})
-- 		end,
-- 	},
-- })
