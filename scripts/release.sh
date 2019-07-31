branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
echo "release-it patch --preRelease=$branch --ci"