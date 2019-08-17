#!/usr/bin/env bash
#branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
masterRelease="false"
branch=$1
repo=$2
packageName=`jq -r ".name" package.json`

echo "PACKAGE-NAME: $packageName"
echo "BRANCH: $branch"
echo "REPO: $repo"

get_token() {
  echo "$(aws ssm get-parameter --name "githubaccesstoken" --query Parameter.Value --region us-east-1)"
}

tokenQuotes=$(get_token)
tokenStripSuffixQuotes="${tokenQuotes%\"}"
token="${tokenStripSuffixQuotes#\"}"

export GITHUB_TOKEN=$token

releaseResponse=`release-it patch --preRelease=$branch --ci`
RC=$?
echo $releaseResponse

if [ "${RC}" != "0" ]
then
  echo "RELEASE FAILED"
else 
  echo "RELEASE SUCCESS"
  sleep 5
  versions=`npm view $packageName versions --json`
fi

export versions
export branch
export repo
export masterRelease

python scripts/slack.py




