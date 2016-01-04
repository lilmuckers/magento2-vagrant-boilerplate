export PATH=$PATH:/var/www/mage2/bin

function parse_git_branch_and_add_brackets {
 git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
export PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \[\e[1;31m\]\$(parse_git_branch_and_add_brackets)\[\033[01;34m\]\$\[\033[00m\] "
