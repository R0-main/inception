FROM debian:bullseye

RUN apt update && apt-get -y install sudo
RUN sudo apt-get install -y lsb-release curl gpg procps
RUN curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
RUN sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
RUN sudo apt-get -y update
RUN sudo apt-get -y install redis

COPY ./tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 6379

RUN mkdir -p /run/redis
RUN chown redis:redis /run/redis

USER redis

VOLUME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
