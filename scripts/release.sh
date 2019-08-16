#!/usr/bin/env bash
#branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
branch=$1
repo=$2
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
echo "RELEASE-RESPONSE: $releaseResponse"
RC=$?


if [ "${RC}" != "0" ]
then
  echo "RELEASE FAILED"
else 
  echo "RELEASE SUCCESS"
  sleep 5
  versions=`npm view @paintzen/test_node_module_new versions --json`
  export versions
  export branch
  export repo
fi

pip install urllib3
python scripts/slack.py




