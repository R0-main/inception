FROM debian:bullseye

ARG REDIS_PORT
ENV REDIS_PORT=${REDIS_PORT}

RUN apt update && apt-get -y install sudo
RUN sudo apt-get install -y lsb-release curl gpg procps
RUN curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
RUN sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
RUN sudo apt-get -y update
RUN sudo apt-get -y install redis

RUN mkdir -p /run/redis
RUN chown redis:redis /run/redis

USER redis

VOLUME /data
WORKDIR /data

EXPOSE ${REDIS_PORT}

CMD exec redis-server --protected-mode no --bind 0.0.0.0 --port ${REDIS_PORT} --daemonize no
