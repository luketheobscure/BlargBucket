#!/bin/bash
rm -rf docs || exit 0;
mkdir docs 
jazzy -g https://github.com/luketheobscure/BlargBucket -m 'Blarg Bucket'
( cd docs
 git init
 git config user.name "Travis-CI"
 git config user.email "travis@blargbucket"
 git add .
 git commit -m "Deployed to Github Pages"
 git push --force --quiet "https://${GH_TOKEN}@github.com/luketheobscure/BlargBucket" master:gh-pages > /dev/null 2>&1
)
