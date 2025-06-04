# My dotfiles

This repository contains the configuration files (dotfiles) for my system setup.

## Requirements

Ensure you have the following installed on your system:

### Homebrew

Follow the instructions at [Homebrew](https://brew.sh/) to install Homebrew.

### Git

```sh
brew install git
```

### Stow

```sh
brew install stow
```

## Installation

1. Clone the dotfiles repository into your `$HOME` directory:

   ```sh
   git clone https://github.com/yedidyar-ni/dotfiles.git
   cd dotfiles
   ```

2. Use GNU stow to create symlinks for the dotfiles:

   ```sh
   stow .
   ```

3. Install the necessary packages and applications using Homebrew:

   ```sh
   brew bundle
   ```

## Configuration

### Zsh

The `.zshrc` file contains various configurations and functions. Ensure you have Zsh installed and set as your default shell. You can install Zsh using Homebrew:

```sh
brew install zsh
```

### Powerlevel10k

To customize your prompt, run `p10k configure` or edit `~/.p10k.zsh`. Ensure Powerlevel10k is installed:

```sh
brew install romkatv/powerlevel10k/powerlevel10k
```

### NVM

The `.zshrc` file includes configurations for NVM (Node Version Manager). Ensure NVM is installed:

```sh
brew install nvm
```

### Additional Tools

The `Brewfile` includes various tools and applications. You can install them using:

```sh
brew bundle
```

### Visual Studio Code Extensions

The `Brewfile` also includes a list of Visual Studio Code extensions. You can install them using:

```sh
brew bundle
```

## Usage

After setting up the repository and installing the necessary tools, you can start using your customized environment. Make sure to restart your terminal or source the `.zshrc` file:

```sh
source ~/.zshrc
```

Enjoy your personalized setup!
