#!/usr/bin/env bash
#branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
branch=$1
echo "BRANCH: $branch"

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
  versions=`npm view @paintzen/test_node_module_new versions --json`
  echo "VERSIONS:$versions" 
  export versions
  export branch
fi

python - << EOF
import os 
import json
npmversions = os.environ["versions"]
branch = os.environ["branch"]
data=json.loads(npmversions)
latestversion = data[-1]
for version in reversed(data): 
  if branch in version: 
    latestversion=version
print("latestversion", latestversion)
os.environ["latestversion"], latestversion)
EOF


echo "LATESTVERSION: $latestversion"


