#/bin/bash

# Git repo can't be specified directly in 'docker build' command because build context is in a different direcotry than the Dockerfile
rm /tmp/mitemp2 -fr
git clone https://github.com/JsBergbau/MiTemperature2.git /tmp/mitemp2
(cd /tmp/mitemp2; git checkout 38627a5a980c842d201e6b812f453899d05cc48a)

docker build -t mitemp2-without-prom -f /tmp/mitemp2/docker/Dockerfile /tmp/mitemp2

docker run -d --name=mitemp2-without-prom --entrypoint "/bin/sleep" mitemp2-without-prom infinity
docker exec -it mitemp2-without-prom pip install -r /app/prometheus/requirements.txt
docker commit --change='ENTRYPOINT ["python3", "/app/LYWSD03MMC.py"]' mitemp2-without-prom mitemp2

docker container stop mitemp2-without-prom
docker container rm mitemp2-without-prom
docker image rm mitemp2-without-prom
