#!/bin/sh

echo '
if [ -f ~/.bash_profile ] ; then
	. ~/.bash_profile
fi
' >> ${HOME}/.bashrc
 
echo '
if [[ -d "$HOME/.composer/vendor/bin" && -z $(echo $PATH | grep -o "$HOME/.composer/vendor/bin") ]] ; then
	PATH=$HOME/.composer/vendor/bin:$PATH
fi
' >> ${HOME}/.bash_profile

chown 1000:1000 ${HOME}/.bash_profile
. $HOME/.bashrc