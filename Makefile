SERVER = neovim zsh
PC = $(SERVER) alacritty chrome
DEPENDENCIES = stow git python3 pip

check:
	@echo "Performing dependency check..."
	@for i in $(DEPENDENCIES); do \
		if ! command -v $$i > /dev/null; then \
			echo "$$i is not installed!!!"; \
			exit 1; \
		else \
			echo "$$i is installed"; \
		fi; \
	done
	@echo "All dependencies are met...";echo ''

server:
	@make check
	@for i in $(SERVER); do \
		if test -f $$i.py ; then \
			if python3 $$i.py pre; then \
				stow -vS -R -t ~ $$i --override=.*; \
				if test -f $$i.py ; \
					then python3 $$i.py post; \
				fi; \
			fi; \
		fi; \
	done

pc:
	@make check
	@for i in $(PC); do \
		if test -f $$i.py ; then \
			if python3 $$i.py pre; then\
				stow -vS -R -t ~ $$i --override=".*"; \
				if test -f $$i.py ; \
					then python3 $$i.py post; \
				fi; \
			fi; \
		fi; \
	done
