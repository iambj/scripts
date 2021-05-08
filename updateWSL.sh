#! /bin/zsh

source ~/.zshrc
# Full update
sudo apt update -y && sudo apt upgrade -y
#powerlevel
git -C "$ZSH_CUSTOM"/themes/powerlevel10k pull


#update node
echo "Checking on Node and NPM... may hang... ⌛"
nvm install node

# sudo npm install -g npm@latest
npm install -g npm@next

# display outdated npm modules
sudo npm i -g npm-check-updates

sudo npm outdated -g

echo "Done updating everything! 👏"

