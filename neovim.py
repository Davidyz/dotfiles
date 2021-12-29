import os
import shutil
import sys

HOME = os.path.expanduser('~')
commands = [
    """sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'""",
    "python -m ensurepip",
    "python -m pip install jupytext flake8 black neovim"
]

if shutil.which("pacman"):
    if shutil.which('node') is None:
        commands.append("sudo pacman -S nodejs")
    if shutil.which('yarn') is None:
        commands.append("sudo pacman -S yarn")
elif shutil.which("apt"):
    extra_commands = []
    if shutil.which('yarn') is None:
        extra_commands.append("curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -")
        extra_commands.append("echo deb https://dl.yarnpkg.com/debian/ stable main | sudo tee /etc/apt/sources.list.d/yarn.list""")
        extra_commands.append("sudo apt update && sudo apt install yarn -y")
    elif shutil.which('node') is None:
        extra_commands.append("curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -")
        extra_commands.append("sudo apt update && sudo apt install nodejs -y")
    commands.extend(extra_commands)

def pre():
    if not os.path.isdir(os.path.expanduser(f'{HOME}/.config/nvim')):
        os.makedirs(f'{HOME}/.config/nvim')
    if os.path.isfile(os.path.expanduser(f'{HOME}/.config/nvim/init.vim')) and not os.path.islink(os.path.expanduser(f'{HOME}/.config/nvim/init.vim')):
        os.system(f'rm {HOME}/.config/nvim/init.vim')
    if os.path.isfile(os.path.expanduser(f'{HOME}/.config/nvim/coc-settings.json')) and not os.path.islink(os.path.expanduser(f'{HOME}/.config/nvim/coc-settings.json')):
        os.system(f'rm {HOME}/.config/nvim/coc-settings.json')

def post():
    for command in commands:
        os.system(command)

    os.system('nvim +:PlugInstall +:CocUpdate +:qa')
    os.system('env EDITOR=nvim')

if __name__ == '__main__':
    if 'pre' in sys.argv:
        pre()
    elif 'post' in sys.argv:
        post()
