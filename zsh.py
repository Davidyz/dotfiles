import os
import shutil
import sys

HOME = os.path.expanduser("~")
ZSH_PATH = os.path.expanduser(f"{HOME}/.oh-my-zsh/")
ZSH_CUSTOM_PATH = os.path.join(ZSH_PATH, "custom")
ZSH_CUSTOM = ZSH_CUSTOM_PATH if os.path.isdir(ZSH_CUSTOM_PATH) else None
ZSH = ZSH_PATH if os.path.isdir(ZSH_PATH) else None

plugins = {
    "ipython-selector": "https://github.com/Davidyz/ipython-selector",
    "zsh-autosuggestions": "https://github.com/zsh-users/zsh-autosuggestions",
    "zsh-syntax-highlighting": "https://github.com/zsh-users/zsh-syntax-highlighting.git",
    "zsh-256color": "https://github.com/chrissicool/zsh-256color",
    "zsh-completions": "https://github.com/zsh-users/zsh-completions",
    "docker": "https://github.com/srijanshetty/docker-zsh.git",
    "zsh-autopair": "https://github.com/hlissner/zsh-autopair.git",
    "zsh-autocomplete": "https://github.com/marlonrichert/zsh-autocomplete.git",
    "autoupdate": "https://github.com/TamCore/autoupdate-oh-my-zsh-plugins",
    "zsh-colored-man-pages": "https://github.com/ael-code/zsh-colored-man-pages.git",
}

themes = {"powerlevel10k": "https://github.com/romkatv/powerlevel10k.git"}


def pre():
    if (not os.path.islink(os.path.expanduser(f"{HOME}/.zshrc"))) and os.path.isfile(
        os.path.expanduser(f"{HOME}/.zshrc")
    ):
        os.system(f"mv {HOME}/.zshrc {HOME}/.zshrc.old")


def post():
    if isinstance(ZSH_CUSTOM, str):
        os.chdir(os.path.realpath(os.path.join(ZSH_CUSTOM, "plugins")))
        for name in plugins:
            url = plugins[name]
            if not name in os.listdir():
                os.system(f"git clone --depth 1 {url} {name}")

        os.chdir(os.path.realpath(os.path.join(ZSH_CUSTOM, "themes")))
        for name in themes:
            url = themes[name]
            if not name in os.listdir():
                os.system(f"git clone {url} {name}")


if __name__ == "__main__":
    if "pre" in sys.argv:
        if ZSH is None:
            if shutil.which("zsh"):
                os.system(
                    'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
                )
            else:
                print("zsh not found. Exitting.")
                exit(1)
        pre()

    elif "post" in sys.argv:
        post()
