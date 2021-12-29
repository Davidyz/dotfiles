SERVER = neovim zsh
PC = alacritty

server:
	for i in $(SERVER); do \
		stow -vS -t ~ $$i --override=.*; \
		if test -f $$i.py ; \
			then python $$i.py; \
		fi; \
	done

pc:
	make server
	for i in $(PC); do \
		stow -vS -t ~ $$i --override=".*"; \
		if test -f $$i.py ; \
			then python $$i.py; \
		fi; \
	done
