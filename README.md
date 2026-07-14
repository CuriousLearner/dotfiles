# CuriousLearner's Dotfiles

![Build Status](https://github.com/CuriousLearner/dotfiles/actions/workflows/main.yml/badge.svg?branch=master)

This is a collection of dotfiles and scripts I use for customizing my dev-setup. It contains all my configuration files. See https://dotfiles.github.io/ for more details.

OS related setup scripts can be found in `setup` folder.

## Features

* Sane defaults for macOS
* Zsh with Powerlevel10k, autosuggestions, and syntax highlighting
* Fast shell startup and a curated CLI toolset (mise, yazi, zoxide, fzf)
* Editor and terminal configs: Zed, Ghostty, VS Code
* Git config and aliases
* vim

## Setup

### 1. Clone the repository

```shell
cd ~
git clone --recursive https://github.com/CuriousLearner/dotfiles.git
cd ~/dotfiles
```

### 2. Install Mac dependencies (macOS only)

```shell
bash setup/setup_mac.sh
```

### 3. Set macOS defaults (optional)

```shell
bash setup/osx_defaults.sh
```

### 4. Create symlinks

This uses [GNU stow](https://www.gnu.org/software/stow/) to symlink every dotfile package (shell, zsh, git, editors, terminal, etc.) from your home directory into this repo, keeping everything maintainable in git:

```shell
bash install.sh
```

Each top-level directory is a stow "package" whose contents mirror where they land under `$HOME` (e.g. `zsh/.zshrc` → `~/.zshrc`, `ghostty/.config/ghostty/config` → `~/.config/ghostty/config`).

### 5. Install Python packages

```shell
pip3 install -r setup/requirements.pip
```

### 6. Set up VS Code (optional)

Zed, Ghostty, and yazi configs are already symlinked by `install.sh` (step 4). VS Code is separate because it also installs extensions and lives in a non-standard path:

```shell
cd ~/dotfiles/setup/vscode && bash setup-vs-code.sh   # VS Code settings + extensions
```

Zed is the primary editor; VS Code stays configured for the projects that need it.

**Tip:** Use the alias `eve` to regenerate the VS Code extensions list in `~/dotfiles/setup/vscode/install-extensions.sh`

### 7. Link private Claude config (optional)

```shell
git clone <your-private-claude-config-repo> claude-config   # not tracked here, clone it yourself
bash setup/claude-config.sh
```

Symlinks skills, `CLAUDE.md`, `settings.json`, and `mcp.json` from that repo into `~/.claude/`.
It's intentionally not a git submodule, so this public repo never references its name or URL —
the script just checks whether `claude-config/` exists and skips quietly if it doesn't.

## Updating

On a machine that is already set up, pull the latest and re-stow:

```shell
cd ~/dotfiles && git pull && bash install.sh
```

`stow` is idempotent, so re-running `install.sh` just refreshes the symlinks.

### One-time migration from the old `bootstrap.sh` layout

If a machine was set up before the move to [GNU stow](https://www.gnu.org/software/stow/) (when dotfiles were symlinked straight from the repo root), those old symlinks now point at files that have moved into package directories, so they are broken. Clean up the stale links once, then stow:

```shell
cd ~/dotfiles && git pull

# Remove the now-broken symlinks the old bootstrap created (broken links that
# still point into this repo), then let stow recreate them in the new layout.
for l in ~/.[!.]* ~/.config/*/*; do
    [ -L "$l" ] && [ ! -e "$l" ] && readlink "$l" | grep -q /dotfiles/ && rm "$l"
done

brew install stow   # if not already installed
bash install.sh
```

After this one-time cleanup, future updates are just the `git pull && bash install.sh` above.

## Resources

I actively watch the following repositories and add the best changes to this repository:

- [GitHub ❤ ~/](https://dotfiles.github.io/)
- [Saurabh Kumar's dotfiles](https://github.com/theskumar/dotfiles)
- [Nick S. Plekhanov’s dotfiles](https://github.com/nicksp/dotfiles)

## Not Exactly What You Want?

This is what I want. It might not be what you want. Don't worry, you have options:

### Fork This

If you have differences in your preferred setup, I encourage you to fork this to create your own version. Once you have your fork working, let me know and I'll add it to a 'Similar dotfiles' list here. It's up to you whether or not to rename your fork.

### Or Submit a Pull Request

I also accept pull requests on this, if they're small, atomic, and if they make my own project development experience better.

## License

The code is available under the [MIT license](LICENSE).
