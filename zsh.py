import os, shutil
ZSH_PATH = os.path.expanduser('~/.oh-my-zsh/')
ZSH_CUSTOM_PATH = os.path.join(ZSH_PATH, 'custom')
ZSH_CUSTOM = ZSH_CUSTOM_PATH if os.path.isdir(ZSH_CUSTOM_PATH) else None
ZSH = ZSH_PATH if os.path.isdir(ZSH_PATH) else None

plugins = {
    "zsh-autosuggestions": "https://github.com/zsh-users/zsh-autosuggestions",
    "zsh-syntax-highlighting": "https://github.com/zsh-users/zsh-syntax-highlighting.git",
    "zsh-256color": "https://github.com/chrissicool/zsh-256color",
    "zsh-completions": "https://github.com/zsh-users/zsh-completions",
    "docker": "git@github.com:srijanshetty/docker-zsh.git"
}

themes = {
        "powerlevel10k": "https://github.com/romkatv/powerlevel10k.git"
        }

if ZSH is None:
    if shutil.which('zsh'):
        os.system('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
    else:
        print("zsh not found. Exitting.")
        exit(0)

if (not os.path.islink('~/.zshrc')) and os.path.isfile('~/.zshrc'):
    os.system('mv ~/.zshrc, ~/.zshrc.old')

if isinstance(ZSH_CUSTOM, str):
    os.chdir(os.path.realpath(os.path.join(ZSH_CUSTOM, 'plugins')))
    for name in plugins:
        url = plugins[name]
        if not name in os.listdir():
            os.system(f'git clone {url} {name}')

    os.chdir(os.path.realpath(os.path.join(ZSH_CUSTOM, 'themes')))
    for name in themes:
        url = themes[name]
        if not name in os.listdir():
            os.system(f'git clone {url} {name}')
