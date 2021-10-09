git checkout master
git pull github-origin master
rm .gitignore
cp .gitignore-github .gitignore
git add *
git commit -am "-"
git push github-origin master