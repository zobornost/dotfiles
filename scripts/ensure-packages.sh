#!/usr/bin/env bash
set -euo pipefail

DNF_LIST="$HOME/.dotfiles/packages/dnf"
FLATPAK_LIST="$HOME/.dotfiles/packages/flatpak"

echo "Ensuring DNF packages..."
if [[ -f "$DNF_LIST" ]]; then
	missing=$(comm -23 <(sort "$DNF_LIST") <(dnf list installed --qf '%{name}' | sort))
	if [[ -n "$missing" ]]; then
		sudo dnf install -y $missing
	else
		echo "All DNF packages already installed"
	fi
else
	echo "No DNF package list found"
fi

echo "Ensuring Flatpak packages..."
if [[ -f "$FLATPAK_LIST" ]]; then
	if ! flatpak remote-list | grep -q flathub; then
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	fi

	while read -r app; do
		[[ -z "$app" ]] && continue
		if ! flatpak list --app --columns=application | grep -qx "$app"; then
			echo "Installing $app"
			flatpak install -y flathub "$app"
		fi
	done < "$FLATPAK_LIST"
else
	echo "No Flatpak package list found"
fi

echo "Package ensure complete"
