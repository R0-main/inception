FROM debian:bullseye

RUN apt update && apt-get -y install sudo
RUN sudo apt-get install -y hugo
RUN hugo new site quickstart

WORKDIR /quickstart

RUN hugo new content content/posts/my-first-post.md

EXPOSE 1313

CMD ["hugo", "server", "--bind", "0.0.0.0", "--baseURL", "http://localhost:1313/static"]
