#!/bin/bash

readonly PACKAGES=(
  git
  chezmoi
  keyd
  wezterm
  alacritty
  neovim
  shfmt
  curl
  tmux
  jo
  mpv
  yt-dlp
  jq
  direnv
)

readonly UBUNTU_PACKAGES=(
  shellcheck
  gcc-14
  libgcc-15-dev
  clang-19
  libclang-19-dev
)

readonly ZYPPER_PACKAGES=(
  ShellCheck
  xsel
  qemu
  qemu-arm
  qemu-accel-qtest
  qemu-block-dmg
  qemu-block-gluster
  qemu-block-iscsi
  qemu-block-ssh
  qemu-chardev-baum
  qemu-doc
  qemu-extra
  qemu-ppc
  qemu-s390x
  qemu-skiboot
  qemu-vhost-user-gpu
  qemu-headless
  qemu-linux-user
  docker
  docker-compose
  StyLua
  luajit
  luajit-devel
  keyd
  clang19
  clang19-devel
  gcc14
  gcc14-c++
  efm-langserver
  opi
  fnm
  fnm-bash-completion
  python313
  python313-pipx
  python313-devel
)

readonly PIPX_PACKAGES=(
  basedpyright
  poetry
  ruff
)

if [[ ! -f /etc/os-release ]]; then
  printf "Can't find os-release\n"
  exit 1
fi

source /etc/os-release

printf 'Detected %s.\n' "$ID"
if [[ $ID =~ opensuse* ]]; then
  install_command="zypper in"
  refresh_command="zypper ref"
elif [[ $ID =~ ubuntu* ]]; then
  install_command="apt install"
  refresh_command="apt update"
else
  printf 'Distro not supported (in my rotation) yet.\n'
  exit 1
fi

#shellcheck disable=SC2086
sudo $refresh_command

printf 'Installing basic stuff needed to set this all up\n'

#shellcheck disable=SC2086,SC2048
sudo $install_command -y ${PACKAGES[*]}

# Rust stuff
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
mkdir -p ~/.local/bin
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - >~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

if [[ $ID =~ opensuse* ]]; then
  #shellcheck disable=SC2086,SC2048
  sudo $install_command -y ${ZYPPER_PACKAGES[*]}
  usermod -a -G docker "$USER"
  # fnm
  fnm install --lts
  eval "$(fnm env --use-on-cd --shell bash)"
  npm install -g js-beautify vscode-langservers-extracted typescript typescript-language-server
  #shellcheck disable=SC2086,SC2048
  pipx-3.13 install ${PIPX_PACKAGES[*]}
  pipx-3.13 inject poetry poetry-plugin-shell
  sudo /sbin/qemu-binfmt-conf.sh --persistent yes --systemd ALL
  sudo systemctl start systemd-binfmt
  printf 'To fully enable multi-arch support in docker, run the following:\ndocker run --privileged --rm tonistiigi/binfmt --install all\nReboot afterwards.'
else
  #shellcheck disable=SC2086,SC2048
  sudo $install_command -y ${UBUNTU_PACKAGES[*]}
fi

printf 'Applying stuff from dotfiles repo\n'
chezmoi init --apply xorspark

printf 'Remember to open a new shell/session afterward for the new env vars to take effect (bash -l)\n'
