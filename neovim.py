#!/usr/bin/env python3
import os, shutil

commands = [
    """sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'""",
    """python -m ensurepip""",
    """python -m pip install jupytext flake8 black""",
]

if shutil.which("pacman"):
    commands.append("""sudo pacman -S yarn nodejs""")
elif shutil.which("apt"):
    extra_commands = [
        """curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -""",
        """curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -""",
        """echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list""",
        """sudo apt update && sudo apt-get install -y nodejs yarn""",
    ]
    commands.extend(extra_commands)

for command in commands:
    os.system(command)
