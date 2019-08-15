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

#echo "githubaccestoken = $token currentbranch = $branch"

export GITHUB_TOKEN=$token
echo "$(release-it patch --preRelease=$branch --ci)"
