FROM debian:bullseye

RUN apt update && apt-get -y install sudo curl default-mysql-client iputils-ping

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs
RUN npm install -g --legacy-peer-deps n8n

ARG N8N_PORT

RUN useradd -m -s /bin/bash n8n
RUN mkdir -p /home/n8n/.n8n
RUN chown -R n8n:n8n /home/n8n/.n8n

COPY ./tools/docker-entrypoint.sh /home/n8n/docker-entrypoint.sh
RUN chmod +x /home/n8n/docker-entrypoint.sh
RUN chown n8n:n8n /home/n8n/docker-entrypoint.sh

COPY ./tools/discord_workflow.json /home/n8n/discord_workflow.json
RUN chmod +x /home/n8n/discord_workflow.json
RUN chown n8n:n8n /home/n8n/discord_workflow.json

WORKDIR /home/n8n

USER n8n

EXPOSE ${N8N_PORT}

ENTRYPOINT ["/home/n8n/docker-entrypoint.sh"]
