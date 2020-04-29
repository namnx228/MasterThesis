FROM ubuntu:18.04
MAINTAINER Nam Xuan Nguyen
RUN apt update -y
RUN apt install -y python3-pip iptables
RUN pip3 install python-iptables
ADD multi-tenancy-sidecar.py .
ADD iplist.json .
RUN chmod u+x multi-tenancy-sidecar.py
ENTRYPOINT ["./multi-tenancy-sidecar.py"]
# CMD /bin/bash

