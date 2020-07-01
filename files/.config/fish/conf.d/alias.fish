# lsのショートカット
alias l='ls -l'
alias ll='ls -l'
alias la='ls -la'

# vimfiler
alias vf='vim +VimFiler'

alias top='top -o mem'

function git_config
    set branch_name($argv)
    git config branch.$branch_name.remote origin
    git config branch.$branch_name.remote.merge refs/heads/$branch_name.remote
end

function dsize
    sudo du / | sort -nr | head -n 100
end

function rm_caches
    sudo rm -rf /System/Library/Caches/* /Library/Caches/* ~/Library/Caches/*
end

function jupyter
    cd ~/github/jupyter
    docker-compose up -d
    open http://localhost:8888
end

function redash
    cd ~/github/redash
    docker-compose up -d
    open http://localhost
end

function mysql_local
    mysql -h 127.0.0.1 -P 3306 -u mc_rw -ppassword morning_code
end

set -x PATH $HOME/.cargo/bin $PATH

set -x PATH /usr/local/share/sonar-scanner/bin $PATH
