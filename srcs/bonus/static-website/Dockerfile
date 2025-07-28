FROM debian:bullseye

ARG STATIC_WEBSITE_PORT
ENV STATIC_WEBSITE_PORT=${STATIC_WEBSITE_PORT}

RUN apt update && apt-get -y install sudo
RUN sudo apt-get install -y hugo
RUN hugo new site quickstart

WORKDIR /quickstart

COPY ./conf/ /quickstart/

RUN hugo new content content/posts/my-first-post.md

EXPOSE ${STATIC_WEBSITE_PORT}

CMD hugo server --bind 0.0.0.0 -p ${STATIC_WEBSITE_PORT}
