#!/bin/bash

#set -x

REPO_LIST="ABC ssh repo_jan test"

get_latest_commit (){
    REPO_NAME=$1
    curl -s -u prakashreddy134:57a3e6100426c719d448f63ff95720e43f1dde89 https://api.github.com/repos/Prakashreddy134/$REPO_NAME/commits/master | \
    #curl -s https://api.github.com/repos/shanmukha511/$REPO_NAME/commits/master
        grep sha | \
        awk '{print $2}'| \
        sed -n '1'p | \
        sed 's/"//g'| \
        sed 's/,//g'
}

compare_the_commits () {
        if [ "`cat $FILE`" = "`get_latest_commit $1`" ]
        then
            #echo "There are no changes in $1 repo"
                        j=0
        else
            STATUS=changed
            get_latest_commit $1 > $FILE
        fi
}

main () {
ARRAY=()
for i in $REPO_LIST
do
    FILE=/var/lib/jenkins/${i}_latest_commit.txt
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
           job=test-deploy-job
           ARRAY+=("$job")
          # echo "$URL"
           #echo "$job"
          # echo "There are changes in $i repo"
        elif [ "$i" = "repo_jan" ]
        then
           URL=https://github.com/Prakashreddy134/repo_jan/blob/master/test.txt
           job=repo_jan
           ARRAY+=("$job")
           #echo "$URL"
           #echo "$job"
           #echo "There are changes in $i repo"
       elif [ "$i" = "ssh" ]
        then
           URL=https://github.com/Prakashreddy134/ssh/blob/master/test.txt
           job=ssh
           ARRAY+=("$job")
           #echo "$URL"
          #echo "$job"
       #echo "There are changes in $i repo"
       elif [ "$i" = "ABC" ]
        then
           URL=https://github.com/Prakashreddy134/ssh/blob/master/test.txt
           job=ABC
           ARRAY+=("$job")
       fi
      STATUS=unchanged
    fi
done
}
#echo "${ARRAY[*]}"

main
echo "${ARRAY[*]}"
