#!/bin/bash
masterRelease="true"
packageName=`jq -r ".name" package.json`
echo "PACKAGE-NAME: $packageName"

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
    releaseResponse=`release-it major --ci`
elif [ $branch = "prod-support" ]
then 
    releaseResponse=`release-it minor --ci`
elif [ $branch = "hotfix" ]
then 
    releaseResponse=`release-it patch --ci`
else 
    echo "Please enter a valid branch name: develop, production-support, or hotfix"
    exit 1
fi

RC=$?
echo $releaseResponse

if [ "${RC}" != "0" ]
then
  echo "RELEASE FAILED"
  exit 1
else 
  echo "RELEASE SUCCESS"
  sleep 5
  versions=`npm view $packageName version`
fi

export versions
export masterRelease
export packageName