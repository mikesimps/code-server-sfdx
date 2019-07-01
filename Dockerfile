FROM codercom/code-server as build
USER root

RUN apt-get update && apt-get install -y \
        openjdk-8-jdk \
        bsdtar \
        fonts-firacode \
        zsh \
        jq
RUN chsh -s /usr/bin/zsh

# # Install Salesforce CLI binary
RUN mkdir sfdx \
    && wget -qO- https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz | tar xJ -C sfdx --strip-components 1 \
    && sfdx/install \
    && rm -rf sfdx

ENV SFDX_AUTOUPDATE_DISABLE=false \
  SFDX_DOMAIN_RETRY=300 \
  SFDX_DISABLE_APP_HUB=true \
  SFDX_LOG_LEVEL=DEBUG \
  TERM=xterm-256color

USER coder
WORKDIR /home/coder/
COPY --chown=coder:coder bin /usr/bin
COPY --chown=coder:coder extensions.list /tmp/extensions.list
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN sfdx update

ENTRYPOINT ["startup.sh"]
