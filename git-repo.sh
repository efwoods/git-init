#!/bin/bash
# Create a new git repo
# $1 repo name
# run file with . ./git-init reponame

main(){
    CONFIGFILE="./.config"
    TOKENFILE="./.gitauthtoken"
    USEREMAIL=""
    USERNAME=""
    TOKEN=""
    config=()
    while IFS=$'\n' read -a line; do config+=(${line}); done < $CONFIGFILE;
    USEREMAIL=${config[0]}
    USERNAME=${config[1]}
    read TOKEN < $TOKENFILE

    if [ $USEREMAIL == "" || $USERNAME == "" || $USEREMAIL == "#git-user.email" || $USERNAME == "#git-user.name"  || $TOKEN == "" || $TOKEN == "#gitauthtoken" ]; then
        echo "Set git user.email config"
        read USEREMAIL
        echo USEREMAIL > .config
        
        echo "Set git user.name config"
        read USERNAME
        echo USERNAME >> .config

        echo "set git Auth Token"
        read TOKEN
        echo TOKEN > .gitauthtoken

        config=()
        while IFS=$'\n' read -a line; do config+=(${line}); done < $CONFIGFILE;
        USEREMAIL=${config[0]}
        USERNAME=${config[1]}
        read TOKEN < TOKENFILE
    fi

    if [ $USEREMAIL == "" || $USERNAME == "" || $USEREMAIL == "#git-user.email" || $USERNAME == "#git-user.name" || $TOKEN == "" || $TOKEN == "#gitauthtoken" ]; then
        echo "error setting config"
    else
        echo "Git user.email set to: $USEREMAIL"
        echo "Git user.name set to: $USERNAME"
        echo "Git Auth Token set"

        REPONAME=$1
        echo "REPONAME: is $1"
        mkdir $HOME/$REPONAME 
        cd $HOME/$REPONAME
        echo "created repo and moved to $pwd"
        git init
        echo "initialized git repository"
        echo "# $1 Repository" >> README.md
        echo "created initial README"

        git config user.email $USEREMAIL
        git config user.name $USERNAME
        DATASTRING='{"name":"'
        DATASTRING+=$REPONAME
        DATASTRING+='","homepage":"https://github.com","private":false,"has_issues":true,"has_projects":true,"has_wiki":true}'

        curl -H "Authorization: token $TOKEN" --request POST --data $DATASTRING https://api.github.com/user/repos
        ORIGIN="https://github.com/$USERNAME/$REPONAME.git"
        git remote add origin $ORIGIN
        git push -u origin master

        git status
        git add * 
        git status
        git commit -m 'init'
        git push --set-upstream origin master
        echo "repo created at $HOME/$REPONAME"
    fi
}

if [ $1 == "" ]; then
    echo "ERROR enter repo name"
    echo "script syntax:. ./git-repo.sh [REPONAME]"
else
    main $1
fi