# Fix Time Differences due to dual boot Windows 10 and Ubuntu 18.04
echo "Fix Time Differences due to dual boot Windows 10 and Ubuntu 18.04"
timedatectl set-local-rtc 1 --adjust-system-clock

# Set up Terminal
echo "Set up Terminal"
sudo apt install -y zsh curl git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo apt install -y tilix
sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh

cat >> ~/.zshrc <<EOL
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi
EOL

# Install ibus-teni
echo "Install ibus-teni"
sudo add-apt-repository -y ppa:teni-ime/ibus-teni
sudo apt-get update
sudo apt-get install -y ibus-teni
ibus restart
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'teni')]"

# Install GNOME tweak tool and Arc theme
echo "Install GNOME tweak tool and Arc theme"
sudo add-apt-repository -y ppa:noobslab/icons
sudo apt install -y gnome-tweak-tool arc-theme arc-icons
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Arc-Icons'

# Remove Thunderbird
echo "Remove Thunderbird"
sudo apt remove -y --autoremove thunderbird

# Install Google Chrome
echo "Install Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Install VSCode
echo "Install VSCode"
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install -y code

sudo gpgconf --kill dirmngr
sudo chown -R $USER:$USER ~/.gnupg

# Set Favourite apps on dock
echo "Set Favourite apps on dock"
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'google-chrome.desktop', 'code.desktop', 'org.gnome.Nautilus.desktop', 'rhythmbox.desktop']"

# Install PHP dev environment
echo "Install PHP dev environment"
echo "- PHP"
sudo apt install -y php php-pear php-fpm php-dev php-zip php-curl php-xmlrpc php-gd php-mysql php-mbstring php-xml
echo "- Composer"
sudo apt install -y composer
sed '3iexport PATH="\$HOME/.config/composer/vendor/bin:\$PATH"' ~/.zshrc > ~/.zshrc_new
mv ~/.zshrc ~/.zshrc_old
mv ~/.zshrc_new ~/.zshrc
echo "- Valet linux"
sudo apt install -y network-manager libnss3-tools jq xsel
composer global require cpriego/valet-linux
valet install
mkdir ~/code
cd ~/code
valet park
cd ~
valet domain ".dev"
echo "- Laravel Installer"
composer global require laravel/installer
echo "- PHP CS Fixer"
composer global require friendsofphp/php-cs-fixer
