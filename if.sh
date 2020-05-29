#!/bin/bash

#set -x

REPO_LIST="ABC XYZ"

get_latest_commit (){
    REPO_NAME=$1
    #curl -s -u prakashreddy134:ec26b80c7159b9d5a42d48c358eff263d99ff8bf https://api.github.com/repos/Prakashreddy134/$REPO_NAME/commits/master | \
    curl -s -u shanmukha511:42cfb4aa5cae146b22cd077175e9471944ba52d8 https://api.github.com/repos/shanmukha511/$REPO_NAME/commits/master | \
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
        if [ "$i" = "ABC" ]
        then
           URL=https://github.com/Prakashreddy134/test/blob/master/test.txt
           job=test-deploy-job
           ARRAY+=("$job")
          # echo "$URL"
           #echo "$job"
          # echo "There are changes in $i repo"
        elif [ "$i" = "XYZ" ]
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
       fi
     STATUS=unchanged
    fi
done
}
#echo "${ARRAY[*]}"

main
echo "${ARRAY[*]}"
