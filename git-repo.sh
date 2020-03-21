#!/bin/sh
# Create a new git repo
# $1 repo name

CONFIGFILE="./.config"
USEREMAIL=""
USERNAME=""

configure(){
    config=()
    while IFS=$'\n' read -a line; 
    do
        config+=(${line})
    done < $CONFIGFILE
    USEREMAIL=${config[0]}
    USERNAME=${config[1]}
}

git-repo(){
    REPONAME = $1
    echo "REPONAME: is $1"
    mkdir $HOME/REPONAME && cd $HOME/REPONAME
    echo "created repo and moved to repo"
    git init
    echo "initialized git repository"
    echo "# $1 Repository" >> README.md
    echo "created initial README"
    git status
    git add * 
    git config --user.email USEREMAIL
    git config --user.name USERNAME
    git commit -m 'init'
    git push -u orign master
    echo "repo created at $HOME/$REPONAME"
}

main(){
    configure()
    if USEREMAIL == "" || USERNAME == "" || USEREMAIL == "#git-user.email" || USERNAME == "#git-user.name" 
    do
        echo "Set git user.email config"
        read USEREMAIL
        echo USEREMAIL > config
        
        echo "Set git user.name config"
        read USERNAME
        echo USERNAME >> config
        configure()
    done

    if USEREMAIL == "" || USERNAME == "" || USEREMAIL == "#git-user.email" || USERNAME == "#git-user.name"
        do
            echo "error setting config"
        done
    else
        echo "Git user.email set to: $USEREMAIL"
        echo "Git user.name set to: $USERNAME"
        git-repo() $1
}

if $1 == ""
    echo "ERROR enter repo name"
    echo "script syntax: ./git-repo.sh [REPONAME]"
else
    main() $1