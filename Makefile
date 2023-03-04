SERVER = neovim zsh lsd
PC = $(SERVER) alacritty chrome
DEPENDENCIES = stow git python3 pip npm fzf
WINDOWS = neovim

all:
	@if [ -z $(TARGET) ]; then \
		make check; \
		exit; \
	fi;
	@[ -d $(TARGET) ] && \
		([ -f $(TARGET).py ] && \
			python3 $$i.py pre && \
			stow --adopt -vS -R -t $$HOME $(TARGET) --override=.* && \
			python3 $(TARGET).py post || \
			stow --adopt -vS -R -t $$HOME $(TARGET) --override=.*;) || \
		(echo Target $(TARGET) not found.;
		exit 1;)
	fi;


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
				stow --adopt -vS -R -t $$HOME $$i --override=.*; \
				if test -f $$i.py ; \
					then python3 $$i.py post; \
				fi; \
			fi; \
		else \
			stow --adopt -vS -R -t $$HOME $$i --override=.*; \
		fi; \
	done

pc:
	@make check
	@for i in $(PC); do \
		if test -f $$i.py ; then \
			if python3 $$i.py pre; then\
				stow --adopt -vS -R -t $$HOME $$i --override=".*"; \
				if test -f $$i.py ; \
					then python3 $$i.py post; \
				fi; \
			fi; \
		else \
			stow --adopt -vS -R -t $$HOME $$i --override=.*; \
		fi; \
	done

win:
	@make check
	@for i in $(WINDOWS); do \
		if test -f $$i.py ; then \
			python3 $$i.py pre && python3 $$i.py post; \
		fi; \
	done

*:
	@[ -d $@ ] || (echo $@ is not found. ; exit 1);
	@[ -f $@.py ] && python3 $@.py pre;
	@stow --adopt -vS -R -t $$HOME $@ --override=".*";
	@[ -f $@.py ] && python3 $@.py post;

.PHONY: $(PC)
