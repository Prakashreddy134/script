#!/bin/bash

#set -x
INPUT=repo.json
REPO_NAME=$(jq -r  '.repodetails | keys[] ' $INPUT)

get_latest_commit (){
    REPO_NAMES=$1
    curl -s https://api.github.com/repos/Prakashreddy134/$REPO_NAMES/commits/master | \
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
    ARRAY=()
    for i in $REPO_NAME
    do
        JOB_NAME=$(jq -r  '.[]."'"$i"'" | .jobname | reduce .[1:][] as $j ("\(.[0])"; . + " \($j)")' repo.json)
        GIT_URL=$(jq -r  '.[]."'"$i"'" | .giturl' repo.json)
        FILE=/var/lib/jenkins/workspace/dev_config/${i}_latest_commit.txt
        if [ ! -f $FILE ]
        then
            touch $FILE
        fi

        compare_the_commits $i

        if [ "$STATUS" = "changed" ]
        then
            #echo $i $JOB_NAME $GIT_URL
            ARRAY+=("$JOB_NAME")
            echo "There are changes in $i repo"
            echo "The Git Repo URL: $GIT_URL"
            #echo "The Job Name: $JOB_NAME"
          STATUS=unchanged
        fi
    done
}
main
echo "${ARRAY[*]}" > jobname.txt
cat jobname.txt
