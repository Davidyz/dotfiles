import os
import platform
import shutil
import sys

HOME = os.path.expanduser("~")
CPU_COUNT = os.cpu_count()
if CPU_COUNT is None:
    CPU_COUNT = 1
NVIM_CONFIG_ROOT = os.path.expanduser(
    "~/.config/nvim"
    if not platform.system() == "Windows"
    else "~/AppData/Local/nvim"
)


commands = ["python -m pip install jupytext flake8 black neovim"]

if shutil.which("pacman"):
    if shutil.which("node") is None:
        commands.append("sudo pacman -S nodejs")
    if shutil.which("yarn") is None:
        commands.append("sudo pacman -S yarn")
elif shutil.which("apt"):
    extra_commands = []
    if shutil.which("yarn") is None:
        extra_commands.append(
            "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"
        )
        extra_commands.append(
            "echo deb https://dl.yarnpkg.com/debian/ stable main | sudo tee /etc/apt/sources.list.d/yarn.list"
            ""
        )
        extra_commands.append("sudo apt update && sudo apt install yarn -y")
    elif shutil.which("node") is None:
        extra_commands.append(
            "curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -"
        )
        extra_commands.append("sudo apt update && sudo apt install nodejs -y")
    commands.extend(extra_commands)

elif shutil.which("dnf") != None or shutil.which("yum") != None:
    command = shutil.which("dnf") or shutil.which("yum")
    commands.append(
        f"sudo {command} -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl"
    )
    if shutil.which("npm") is None:
        commands.append(f"sudo {command} install -y npm")
    if shutil.which("yarn") is None:
        commands.append("npm install --global yarn")


def pre():
    INIT_VIM = os.path.join(NVIM_CONFIG_ROOT, "init.vim")
    INIT_LUA = os.path.join(NVIM_CONFIG_ROOT, "init.lua")
    COC_JSON = os.path.join(NVIM_CONFIG_ROOT, "coc-settings.json")
    if (not os.path.isdir(NVIM_CONFIG_ROOT)) or os.path.islink(
        NVIM_CONFIG_ROOT
    ):
        if os.path.islink(NVIM_CONFIG_ROOT):
            os.remove(NVIM_CONFIG_ROOT)
        os.makedirs(NVIM_CONFIG_ROOT)
    for file in (INIT_VIM, INIT_LUA, COC_JSON):
        if os.path.isfile(file):
            if os.path.islink(file):
                os.remove(file)
            else:
                os.rename(file, file + ".bak")

    for command in commands:
        os.system(command)


def post():
    os.system(
        "nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
    )
    if not platform.system() == "Windows":
        os.system("env EDITOR=nvim")


if __name__ == "__main__":
    if "pre" in sys.argv:
        if shutil.which("nvim") is None:
            wd = os.getcwd()
            os.chdir(os.path.expanduser("~"))
            if "git" in os.listdir():
                os.chdir("git")
            if shutil.which("yay"):
                os.system("yay -S neovim-nightly-bin")
            elif shutil.which("apt"):
                if not os.path.isdir("neovim"):
                    os.system("git clone git@github.com:neovim/neovim.git")
                os.system("cd neovim && checkout nightly")
                os.system(
                    "sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen"
                )
                os.system(f"make -j{os.cpu_count()}")
                os.system("sudo make install")
            else:
                print("Neovim executable is not found.")
                exit(1)
            os.system("pip install neovim pynvim")
            os.system("npm install -g neovim")
            os.chdir(wd)

        if shutil.which("nvim") is None:
            print("Neovim executable is not found. Abouting.")
            sys.exit(1)
        pre()
    elif "post" in sys.argv:
        post()
