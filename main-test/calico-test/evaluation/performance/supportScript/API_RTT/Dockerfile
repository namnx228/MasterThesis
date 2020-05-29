FROM ubuntu:18.04
MAINTAINER Nam Xuan Nguyen
RUN apt update -y
RUN apt-get install curl -y
COPY curl-format ./
COPY run.sh /run.sh
ENTRYPOINT ["/bin/bash"]
