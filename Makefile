SERVER = neovim zsh
PC = alacritty

server:
	for i in $(SERVER); do \
		stow -vSt ~ $$i --override=.*; \
		done

pc:
	make server
	for i in $(PC); do \
		stow -vSt ~ $$i --override=.*; \
		done
