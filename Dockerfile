FROM python:3.6

USER root

# Install Go 1.13
RUN curl -fSL https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz -o golang.tar.gz
RUN tar xf golang.tar.gz
RUN mv go /usr/local/go-1.13

ENV GOROOT="/usr/local/go-1.13"
ENV PATH="${GOROOT}/bin:${PATH}"

# Install Terraform
RUN curl -fSL https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip -o terraform.zip
RUN unzip terraform -d /opt/terraform
RUN ln -s /opt/terraform/terraform /usr/bin/terraform

# Install AWSCLI
RUN pip install awscli

