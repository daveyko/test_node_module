#!/bin/bash

getReleaseType() {
  OUT=$(git log -1 --pretty=%B)
  if [[ $OUT =~ "HOTFIX:" ]]
  then
    TYPE="hotfix"
  elif [[ $OUT =~ "PROD-SUPPORT:" ]]
  then
    TYPE="prod-support"
  else
    TYPE="develop"
  fi
  echo $TYPE
}

get_token() {
  echo "$(aws ssm get-parameter --name "githubaccesstoken" --query Parameter.Value --region us-east-1)"
}

tokenQuotes=$(get_token)
tokenStripSuffixQuotes="${tokenQuotes%\"}"
token="${tokenStripSuffixQuotes#\"}"

branch=$(getReleaseType)
echo "BRANCH: $branch"

echo "githubaccestoken = $token currentbranch = $branch"

export GITHUB_TOKEN=$token
if [ $branch = "develop" ]
then 
    echo "$(release-it major --ci)"
elif [ $branch = "production-support" ]
then 
    echo "$(release-it minor --ci)"
elif [ $branch = "hotfix" ]
then 
    echo "$(release-it patch --ci)"
else 
    echo "Please enter a valid branch name: develop, production-support, or hotfix"
fi
