#!/usr/bin/env bash
cd ~/paintzen/test_node_module
echo "$(whoami)"
echo "$(pwd)"

branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

get_token() {
  echo "$(aws ssm get-parameter --name "githubaccesstoken" --query Parameter.Value --region us-east-1)"
}

token=$(get_token)

echo "token=$token branch=$branch"

# echo "$( GITHUB_TOKEN=$token release-it patch --preRelease=$branch --ci)"
echo "$( GITHUB_TOKEN="6d8ba0eee99e201a9de2e88a11885f53b4713cc9" npm run testrelease)"