FROM debian:bullseye

RUN apt update && apt-get -y install sudo curl default-mysql-client

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs
RUN npm install -g --legacy-peer-deps n8n

RUN useradd -m -s /bin/bash n8n
RUN mkdir -p /home/n8n/.n8n
RUN chown -R n8n:n8n /home/n8n/.n8n

COPY ./tools/docker-entrypoint.sh /home/n8n/docker-entrypoint.sh
RUN chmod +x /home/n8n/docker-entrypoint.sh

COPY ./tools/init.sql /home/n8n/init.sql
RUN chmod +x /home/n8n/init.sql

WORKDIR /home/n8n

USER n8n
EXPOSE 5678

ENTRYPOINT ["/home/n8n/docker-entrypoint.sh"]
