branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

get_token() {
  echo "$(aws ssm get-parameter --name "githubaccesstoken" --query Parameter.Value --region us-east-1)"
}

token=$(get_token)
echo "token=$token"

export GITHUB_TOKEN=$token
echo "$( release-it patch --preRelease=$branch --ci)"