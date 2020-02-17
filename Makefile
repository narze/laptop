.PHONY: help

help: ## Print command list
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

_prepare:
	@git submodule update --init --recursive

bootstrap: _prepare dotfiles _bootstrap ## Bootstrap new machine

_bootstrap:
	@./install -c config/bootstrap.conf.yml

dotfiles: ## Update dotfiles
	@./install

code: ## Clone Repositories with ghq
	@./install -c config/code.conf.yml --plugin-dir dotbot-ghq

brew: ## Install brew & cask packages
	@./install -c config/packages.conf.yml

tools: ## Install non-brew tools eg. tmux package manager
	@./install -c config/tmux.conf.yml

asdf: ## Install asdf-vm
	@./install -c config/asdf-install.conf.yml
	@./install -c config/asdf.conf.yml --plugin-dir dotbot-asdf

all: _prepare dotfiles _bootstrap code brew tools asdf ## Run all tasks at once
