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
  sleep 5
  versions=`npm view @paintzen/test_node_module_new versions --json`
  echo "VERSIONS:$versions" 
  export versions
  export branch
fi
pip install urllib3
python - << EOF
import os 
import json
import urllib3
http = urllib3.PoolManager()
npmversions = os.environ["versions"]
branch = os.environ["branch"]
data=json.loads(npmversions)
latestversion = data[-1]
for version in data[::-1]: 
  if branch in version: 
    latestversion=version
    break
print("latestversion", latestversion)
encoded_body = json.dumps({
  "text": latestversion
})
r = http.request('POST', 
                'https://hooks.slack.com/services/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', 
                headers={'Content-Type': 'application/json'}, 
                body=encoded_body)
print('slackstatus: ', r.status)
EOF


