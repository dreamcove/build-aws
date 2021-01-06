FROM localstack/localstack:latest

MAINTAINER Chris Watson (chris@dreamcove.com)

# Install Terraform
RUN curl -fSL https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip -o terraform.zip
RUN unzip terraform -d /opt/terraform
RUN ln -s /opt/terraform/terraform /usr/bin/terraform
RUN rm -f terraform.zip

# Install Build Tools
RUN apk add git
RUN apk add go

ENV GOROOT="/usr/local/go"
ENV GOPATH="/root/.go"
ENV PATH="${GOROOT}/bin:${PATH}:${GOPATH}/bin"

# In case Localstack is used external to image
EXPOSE 4566-4597 8080

COPY start.sh /usr/bin
RUN chmod a+x /usr/bin/start.sh

# Run Entrypoint Script
ENTRYPOINT ["/usr/bin/start.sh"]

CMD ["/usr/bin/bash"]
