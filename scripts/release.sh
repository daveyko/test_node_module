branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
release-it patch --preRelease=$branch --ci