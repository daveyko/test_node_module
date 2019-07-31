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