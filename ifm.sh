#!/bin/bash

#set -x

REPO_LIST="ssh repo_jan test"

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
           # echo "There are no changes in $1 repo"
           j=0
        else
            STATUS=changed
            get_latest_commit $1 > $FILE
        fi
}

main () {
for i in $REPO_LIST
do
    FILE=/tmp/${i}_latest_commit.txt
    if [ ! -f $FILE ]
    then
        touch $FILE
    fi

    compare_the_commits $i

    if [ "$STATUS" = "changed" ]
    then
        if [ "$i" = "test" ]
        then
           URL=https://github.com/Prakashreddy134/test/blob/master/test.txt
           job=test-deploy-job,a-job
           #echo "$URL"
           echo "$job"
           #echo "$job" > /tmp/jobname.txt
           #export job="prakash"
           #echo "There are changes in $i repo"
       fi
    fi
done
}

main
