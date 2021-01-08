FROM localstack/localstack:latest

MAINTAINER Chris Watson (chris@dreamcove.com)

# Install Terraform
RUN curl -fSL https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip -o terraform.zip
RUN unzip terraform -d /opt/terraform
RUN ln -s /opt/terraform/terraform /usr/bin/terraform
RUN rm -f terraform.zip

# Install Build Tools
RUN apk update
RUN apk upgrade
RUN apk add .build-deps build-base bash gcc musl-dev openssl go git perl

ENV GOPATH="/root/.go"

# In case Localstack is used external to image
EXPOSE 4566-4597 8080

COPY start.sh /usr/bin
RUN chmod a+x /usr/bin/start.sh

# Run Entrypoint Script
ENTRYPOINT ["/usr/bin/start.sh"]

CMD ["/usr/bin/bash"]

RUN echo ${GOROOT}
RUN go version