#!/bin/bash

if [ $1 == "chocolate" ]
then
sed -i 's/\*neo_vanilla/\*neo_chocolate/g' $HOME/.config/alacritty/alacritty.yml
sed -i 's/background_opacity: 0.5/background_opacity: 0.8/g' $HOME/.config/alacritty/alacritty.yml
ln -sf $HOME/.config/rofi/colorschemes/neo_chocolate.rasi $HOME/.config/rofi/colorschemes/colors.rasi
ln -sf $HOME/.vim/colors/neo_chocolate.vim $HOME/.vim/colors/neopolitan.vim
kvantummanager --set NeoChocolate
sed -i 's/NeoVanilla/NeoChocolate/g' $HOME/.config/gtk-3.0/settings.ini
sed -i 's/NeoVanilla/NeoChocolate/g' $HOME/.gtkrc-2.0
sed -i 's/NeoVanilla/NeoChocolate/g' $HOME/.config/qt5ct/qt5ct.conf
fi

if [ $1 == "vanilla" ]
then
sed -i 's/*neo_chocolate/*neo_vanilla/g' $HOME/.config/alacritty/alacritty.yml
sed -i 's/background_opacity: 0.8/background_opacity: 0.5/g' $HOME/.config/alacritty/alacritty.yml
ln -sf $HOME/.config/rofi/colorschemes/neo_vanilla.rasi $HOME/.config/rofi/colorschemes/colors.rasi
ln -sf $HOME/.vim/colors/neo_vanilla.vim $HOME/.vim/colors/neopolitan.vim
kvantummanager --set NeoVanilla
sed -i 's/NeoChocolate/NeoVanilla/g' $HOME/.config/gtk-3.0/settings.ini
sed -i 's/NeoChocolate/NeoVanilla/g' $HOME/.gtkrc-2.0
sed -i 's/NeoChocolate/NeoVanilla/g' $HOME/.config/qt5ct/qt5ct.conf
fi

