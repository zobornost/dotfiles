# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# nix pkgs wrapper
_nixpkg_args() {
	local out=()
	for arg in "$@"; do
		if [[ "$arg" == -* || "$arg" == *"#"* || "$arg" == */* ]]; then
			out+=("$arg")
		else
			out+=("nixpkgs#$arg")
		fi
	done
	echo "${out[@]}"
}

nix() {
	case "$1" in
		install|add) shift; nix profile install $(_nixpkg_args "$@");;
		uninstall|remove) shift; nix profile remove "$@";;
		upgrade|update) shift; nix profile upgrade $(_nixpkg_args "$@");;
		list) nix profile list;;
		*) command nix "$@";;
	esac
}

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
source -- ~/.local/share/blesh/ble.sh
eval "$(starship init bash)"
PS0=$'\n'
. "$HOME/.cargo/env"

export PATH="$HOME/.cargo/bin:$PATH"
export DNF_CONF="$HOME/.config/dnf/dnf.conf"
