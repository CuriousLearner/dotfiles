# CuriousLearner's Dotfiles

![Build Status](https://github.com/CuriousLearner/dotfiles/actions/workflows/main.yml/badge.svg?branch=master)

This is a collection of dotfiles and scripts I use for customizing my dev-setup. It contains all my configuration files. See https://dotfiles.github.io/ for more details.

OS related setup scripts can be found in `setup` folder.

## Features

* Sane defaults for Mac
* Zsh
* Git
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
sh setup/setup_mac.sh
```

### 3. Set macOS defaults (optional)

```shell
sh setup/osx_defaults.sh
```

### 4. Create symlinks

This creates symbolic links from your home directory to the dotfiles, keeping everything maintainable in git:

```shell
sh bootstrap.sh
```

### 5. Install Python packages

```shell
pip3 install -r setup/requirements.pip
```

### 6. Setup VS Code (optional)

```shell
cd ~/dotfiles/setup/vscode && sh setup-vs-code.sh
```

This creates a symlink to `settings.json` and installs extensions.

**Tip:** Use the alias `eve` to update the VS Code extensions list in `~/dotfiles/setup/vscode/install-extensions.sh`

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
