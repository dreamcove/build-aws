FROM ubuntu:18.04

USER root

# Install dependencies

RUN apt-get update

# Install Python3
RUN apt-get -y install python3 python3-pip

# Install NodeJS
RUN apt-get -y install npm

# Install Java
RUN apt-get -y install openjdk-8-jdk-headless

# Install Misc
RUN apt-get -y install curl libsasl2-dev unzip make git musl-dev
RUN ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

# Install Go 1.13
RUN curl -fSL https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz -o golang.tar.gz
RUN tar xf golang.tar.gz
RUN mv go /usr/local/go-1.13
RUN rm -f golang.tar.gz

ENV GOROOT="/usr/local/go-1.13"
ENV GOPATH="/root/.go"
ENV PATH="${GOROOT}/bin:${PATH}:/root/.local/bin"
ENV LAMBDA_EXECUTOR=local
ENV LAMBDA_REMOTE_DOCKER=0

# Install Terraform
RUN curl -fSL https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip -o terraform.zip
RUN unzip terraform -d /opt/terraform
RUN ln -s /opt/terraform/terraform /usr/bin/terraform
RUN rm -f terraform.zip

# Install AWSCLI / Localstack
RUN pip3 install awscli awscli-local requests "localstack[full]" --upgrade

# Start Localstack
ENTRYPOINT localstack start --host
