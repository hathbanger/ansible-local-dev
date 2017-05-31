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
RUN go install github.com/hathbanger/ansible-local-dev/dev
RUN go build github.com/hathbanger/ansible-local-dev/dev


ENV TERM xterm
EXPOSE 22 1323

CMD ["/usr/sbin/sshd", "-D", "-4"]