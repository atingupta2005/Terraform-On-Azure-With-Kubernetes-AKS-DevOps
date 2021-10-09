```
docker run --name atinrstudio -p 8787:8787 -e PASSWORD=Azure@123456  atingupta2005/rstudio_aks:latest
#docker run --name atinrstudio -p 8787:8787 -e PASSWORD=Azure@123456 rocker/rstudio --name atinrstudio
docker ps
docker exec -it atinrstudio bash
```

- Now create users inside container and also install azure-cli, kubectl etc

- exit out of container

- Commit and push container
```
docker login
docker commit <container-id> atingupta2005/rstudio_aks:latest
docker push atingupta2005/rstudio_aks:latest
```

- Convert Markdown files to sh files
```
find . -name  '*.md' -type f -exec sh -c  "sed 's/\`\`\`//' '{}' >  '{}.sh'" \;
```
