import os
import shutil
import sys

HOME = os.path.expanduser('~')
CPU_COUNT = os.cpu_count()
if CPU_COUNT is None:
    CPU_COUNT = 1

commands = [
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
    if not os.path.isdir(f'{HOME}/.config'):
        os.makedirs(f'{HOME}/.config')
    if not os.path.isdir(f'{HOME}/.config/nvim'):
        os.makedirs(f'{HOME}/.config/nvim')
    if os.path.isfile(os.path.expanduser(f'{HOME}/.config/nvim/init.vim')) and not os.path.islink(os.path.expanduser(f'{HOME}/.config/nvim/init.vim')):
        os.system(f'rm {HOME}/.config/nvim/init.vim')
    if os.path.isfile(os.path.expanduser(f'{HOME}/.config/nvim/coc-settings.json')) and not os.path.islink(os.path.expanduser(f'{HOME}/.config/nvim/coc-settings.json')):
        os.system(f'rm {HOME}/.config/nvim/coc-settings.json')

def post():
    for command in commands:
        os.system(command)

    os.system("nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'")
    os.system('env EDITOR=nvim')

if __name__ == '__main__':
    if shutil.which('nvim') is None:
        wd = os.getcwd()
        os.chdir(os.path.expanduser('~'))
        if 'git' in os.listdir():
            os.chdir('git')
        if shutil.which('yay'):
            os.system('yay -S neovim-nightly-bin')
        elif shutil.which('apt'):
            if not os.path.isdir('neovim'):
                os.system('git clone git@github.com:neovim/neovim.git')
            os.system('cd neovim && checkout nightly')
            os.system('sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen')
            os.system(f'make -j{os.cpu_count()}')
            os.system('sudo make install')
        else:
            exit()
        os.system('pip install neovim pynvim')
        os.system('npm install -g neovim')
        os.chdir(wd)
    if 'pre' in sys.argv:
        pre()
    elif 'post' in sys.argv:
        post()
