FROM ubuntu:20.04

MAINTAINER Chris Watson (chris@dreamcove.com)

USER root

RUN apt-get update

RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

RUN apt-get install -y sudo && \
    adduser user && \
    echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Install Ruby
RUN apt-get -y install ruby-full

# Install Python3
RUN apt-get -y install python3 python3-pip

# Install NodeJS
RUN apt-get -y install npm

# Install Java
RUN apt-get -y install openjdk-8-jdk-headless

# Install Maven
RUN apt-get -y install maven

# Install Misc
RUN apt-get -y install curl libsasl2-dev unzip make git musl-dev file sudo
RUN ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

# Install Go 1.15
RUN curl -fSL https://dl.google.com/go/go1.15.6.linux-amd64.tar.gz -o golang.tar.gz
RUN tar xf golang.tar.gz
RUN mv go /usr/local/go-1.15
RUN rm -f golang.tar.gz

# Install Terraform
RUN curl -fSL https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip -o terraform.zip
RUN unzip terraform -d /opt/terraform
RUN ln -s /opt/terraform/terraform /usr/bin/terraform
RUN rm -f terraform.zip

# Install AWSCLI / Localstack
RUN pip3 install awscli awscli-local requests "localstack[full]" --upgrade

ENV GOROOT="/usr/local/go-1.13"
ENV GOPATH="/root/.go"
ENV PATH="${GOROOT}/bin:${PATH}:/root/.local/bin:/home/linuxbrew/.linuxbrew/bin"
ENV LAMBDA_EXECUTOR=local
ENV LAMBDA_REMOTE_DOCKER=0

# Install Homebrew
USER user
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
RUN git version
RUN locale

USER root
RUN /home/linuxbrew/.linuxbrew/bin/brew update

# Install Hugo
RUN /home/linuxbrew/.linuxbrew/bin/brew install hugo

# In case Localstack is used external to image
EXPOSE 4566-4597 8080

# Start Localstack
ENTRYPOINT localstack start --host
