SERVER = neovim zsh
PC = alacritty

server:
	for i in $(SERVER); do \
		if test -f $$i.py ; \
			then python $$i.py pre; \
		fi; \
		stow -vS -t ~ $$i --override=.*; \
		if test -f $$i.py ; \
			then python $$i.py post; \
		fi; \
	done

pc:
	make server
	for i in $(PC); do \
		if test -f $$i.py ; \
			then python $$i.py pre; \
		fi; \
		stow -vS -t ~ $$i --override=".*"; \
		if test -f $$i.py ; \
			then python $$i.py post; \
		fi; \
	done
