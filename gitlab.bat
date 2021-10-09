git checkout am1
git pull gitlab-origin am1
rm .gitignore
cp .gitignore-gitlab .gitignore
git add *
git commit -am "-"
git push gitlab-origin am1