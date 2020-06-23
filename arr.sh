#!/bin/bash

#set -x

get_latest_commit (){
    REPO_NAME=$1
    curl -s https://api.github.com/repos/Prakashreddy134/$REPO_NAME/commits/master | \
        grep sha | \
        awk '{print $2}'| \
        sed -n '1'p | \
        sed 's/"//g'| \
        sed 's/,//g'
}

compare_the_commits () {
        if [ "`cat $FILE`" = "`get_latest_commit $1`" ]
        then
            echo "There are no changes in $1 repo"
        else
            STATUS=changed
            get_latest_commit $1 > $FILE
        fi
}

main () {
    grep -v "#" repo_list > tmp.txt
    ARRAY=()
    INPUT="tmp.txt"
    OLDIFS=$IFS
    IFS=','
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    while read REPO_NAME JOB_NAME GIT_URL
    do

        FILE=/var/lib/jenkins/workspace/dev_config/${REPO_NAME}_latest_commit.txt
        if [ ! -f $FILE ]
        then
            touch $FILE
        fi

        compare_the_commits $REPO_NAME

        if [ "$STATUS" = "changed" ]
        then
            ARRAY+=("$JOB_NAME")
            echo "There are changes in $REPO_NAME repo"
            echo "The Git Repo URL: $GIT_URL"
            echo "The Job Name: $JOB_NAME"
          STATUS=unchanged
        fi
    done < $INPUT
    IFS=$OLDIFS
}
main
echo "${ARRAY[*]}" > jobname.txt
