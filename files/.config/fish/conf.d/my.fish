set fish_theme slavic-cat

set -g fish_prompt_pwd_dir_length 0

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
end


#if test -f ~/.git-prompt.sh
#  source ~/.git-prompt.sh
#end

#if test -f ~/.git-completion.bash
#  source ~/.git-completion.bash
#end

if test -f ~/.dockerrc
  source ~/.dockerrc
end

# tmux
if test -z $TMUX
  exec tmux
end
alias tmux-copy='tmux save-buffer - | pbcopy'
if test -z $TMUX
  alias pbcopy="reattach-to-user-namespace pbcopy"
end

### Added by the Heroku Toolbelt
set -x PATH /usr/local/heroku/bin $PATH
#set -Ux JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home"
#set -Ux JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-10.0.2.jdk/Contents/Home"
#set -Ux JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-13.0.1.jdk/Contents/Home"

# anyenv
if test -d $HOME/.anyenv
  set -x PATH $HOME/.anyenv/bin $PATH
  status --is-interactive; and source (anyenv init -|psub)
  # for tmux
  for D in (ls $HOME/.anyenv/envs)
    echo "setting PATH for [$D]"
    set -x PATH $HOME/.anyenv/envs/$D/shims $PATH
  end
end

#if [ -d ${HOME}/.anyenv ] ; then
#    set -x PATH "$HOME/.anyenv/bin:$PATH"
#    eval "$(anyenv init -)"
#    # for tmux
#    for D in `ls $HOME/.anyenv/envs`
#    do
#        echo "setting PATH for [$D]"
#        set -x PATH "$HOME/.anyenv/envs/$D/shims:$PATH"
#    done
#fi

# Go
set -Ux GO_VERSION 1.14.0
set -Ux GOROOT $HOME/.anyenv/envs/goenv/versions/$GO_VERSION
set -Ux GOPATH $HOME/go
set -x PATH $HOME/.anyenv/envs/goenv/shims/bin $PATH
set -x PATH $GOROOT/bin $PATH
set -x PATH $GOPATH/bin $PATH
echo Now using golang v$GO_VERSION

# Java
set -Ux JAVA_VERSION openjdk-13.0.1.jdk
set -Ux JAVA_HOME "/Library/Java/JavaVirtualMachines/$JAVA_VERSION/Contents/Home"
set -x PATH $HOME/.anyenv/envs/jenv/shims/bin $PATH
echo Now using java v$JAVA_VERSION

# Python
set -Ux PYTHON_VERSION 3.6.6
echo Now using python $PYTHON_VERSION

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
function sdk
  bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk $argv"
end
for ITEM in $HOME/.sdkman/candidates/* ;
  set -gx PATH $PATH $ITEM/current/bin
end

# AWS CLI
set -x PATH $HOME/.local/bin $PATH

set -x PATH $HOME/github/flex_sdk_3.6a/bin $PATH
#eval (pyenv virtualenv-init -)
