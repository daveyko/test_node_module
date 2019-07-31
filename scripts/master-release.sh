read -p "Enter branch to release: " branch
if [ $branch = "develop" ]
then 
    echo "release-it major --ci"
elif [ $branch = "production-support" ]
then 
    echo "release-it minor --ci"
elif [ $branch = "hotfix" ]
then 
    echo "release-it patch --ci"
else 
    echo "Please enter a valid branch name: develop, production-support, or hotfix"