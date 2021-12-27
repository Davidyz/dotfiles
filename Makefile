SERVER = neovim zsh
PC = alacritty

server:
	for i in $(SERVER); do \
		stow -vSt ~ $$i; \
		done

pc:
	for i in $(PC); do \
		stow -vSt ~ $$i; \
		done
