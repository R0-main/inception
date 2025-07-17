FROM debian:bullseye

RUN apt update && apt-get -y install sudo curl

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs
RUN npm install -g --legacy-peer-deps n8n

RUN useradd -m -s /bin/bash n8n
RUN mkdir -p /home/n8n/.n8n
RUN chown -R n8n:n8n /home/n8n/.n8n

WORKDIR /home/n8n

USER n8n
EXPOSE ${N8N_PORT}

CMD ["n8n"]
