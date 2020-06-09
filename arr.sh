#!/bin/bash

#set -x

REPO_LIST="job1 job2 job3"

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
    FILE=/var/lib/jenkins/workspace/dev_config/${i}_latest_commit.txt
    if [ ! -f $FILE ]
    then
        touch $FILE
    fi

    compare_the_commits $i

    if [ "$STATUS" = "changed" ]
    then
        if [ "$i" = "job1" ]
        then
           URL=https://github.com/Prakashreddy134/job1/blob/master/test.txt
           job=job1
           ARRAY+=("$job")
           echo "There are changes in $i repo"
           echo "The Git Repo URL: $URL"
           echo "The Job Name: $job"
        elif [ "$i" = "job2" ]
        then
           URL=https://github.com/Prakashreddy134/job2/blob/master/test.txt
           job=job2
           ARRAY+=("$job")
           echo "There are changes in $i repo"
           echo "The Git Repo URL: $URL"
           echo "The Job Name: $job"
       elif [ "$i" = "job3" ]
        then
           URL=https://github.com/Prakashreddy134/job3/blob/master/test.txt
           job=job3
           ARRAY+=("$job")
           echo "There are changes in $i repo"
           echo "The Git Repo URL: $URL"
           echo "The Job Name: $job"
       fi
      STATUS=unchanged
    fi
done
}
main
echo "${ARRAY[*]}" > jobname.txt
