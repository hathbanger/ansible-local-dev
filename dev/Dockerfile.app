FROM ubuntu:16.04
RUN apt-get update && \
	apt-get install locales && \
	apt-get install -y \
		iputils-ping \
		openssh-server \
		sudo \
		vim \
		git \
		curl \
		python \
		bzr \
		python-apt

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN apt-get install -y --no-install-recommends software-properties-common
RUN echo "deb http://repo.mongodb.org/apt/ubuntu $(cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d= -f2)/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update && apt-get install -y mongodb-org
RUN mkdir -p /data/db
RUN mongod --fork --logpath /var/log/mongodb.log
RUN locale-gen en_US.UTF-8
WORKDIR /
RUN curl -O https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz && tar xvf go1.6.linux-amd64.tar.gz
RUN rm -rf go1.6.linux-amd64.tar.gz
RUN sudo chown -R root:root ./go && mv go /usr/local
RUN mkdir /var/run/sshd
COPY id_rsa.pub /root/.ssh/authorized_keys
RUN mkdir -p /work/src/github.com/hathbanger
RUN mkdir -p /work/bin
ENV GOBIN /work/bin
ENV PATH /usr/local/go/bin:${GOBIN}:${PATH}
ENV GOPATH /work
RUN curl https://glide.sh/get | sh
WORKDIR /work/src/github.com/hathbanger
RUN git clone https://github.com/hathbanger/ansible-local-dev.git
WORKDIR /work/src/github.com/hathbanger/ansible-local-dev/dev
RUN glide install
# RUN go run main.go

# RUN mongod -d

ENV TERM xterm
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-4"]

