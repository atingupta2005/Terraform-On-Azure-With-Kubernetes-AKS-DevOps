git checkout master
git pull github-origin master
del .gitignore
#rm .gitignore
copy .gitignore-github .gitignore
#cp .gitignore-github .gitignore
git add *
git commit -am "-"
git push github-origin master