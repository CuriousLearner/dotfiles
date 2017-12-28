# CuriousLearner's Dotfiles

This is a collection of dotfiles and scripts I use for customizing my dev-setup. It contains all my configuration files. See http://dotfiles.github.io/ for more details.

OS related setup scripts can be found in `setup` folder.

## Features

* Sane defaults for Mac
* Zsh
* Git
* vim

## Setup

If you are using Mac OSX, this repo includes a script to install dependencies in this [script](setup/setup_mac.sh).

    curl -L http://git.io/curiouslearner-setup-mac | sh

This [script](setup/osx_defaults.sh) will help you add some defaults to your mac.

### Installing dotfiles

Once you have installed basics software and libraries, you can install the dotfiles, by cloning this repo into `~/dotfiles` and symlinking the files inside it to your home directory `~`. Symlinking helps keep all your dotfiles maintainable inside a git repo, while being functional at the same time.

```shell
cd ~ && git clone --recursive git@github.com:curiouslearner/dotfiles.git && cd ~/dotfiles
# To create symbolic links in your home
sh bootstrap.sh  ## this will create the required symlinks
pip install -r requirements.pip  ## essential python packages needed
```

## Resources

I actively watch the following repositories and add the best changes to this repository:

- [GitHub ❤ ~/](http://dotfiles.github.io/)
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
