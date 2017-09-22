#
#
# Ubuntu-based, Angular container
#
#
# Usage
# ================================
# Building / Retrieving Image:
# --------------------------------
# docker build -t kmrd/ng .
# docker pull kmrd/ng
#
#
# Starting the Container:
# --------------------------------
# Nix:
# docker run -u $(id -u) --rm --port 3000:3000 -v "$PWD":/app kmrd/ng ng serve --host 0.0.0.0
# docker run --rm --port 3000:3000 -v "$(PWD)":/home/node/app kmrd/ng ng serve --host 0.0.0.0
#
# Windows:
# docker run --rm --port 3000:3000 -v .:/home/node/app kmrd/ng ng serve --host 0.0.0.0
#
#
# Dev Notes
# ================================
# - Consider using alpine rather than ubuntu since it's more lightweight
# 
# Known Problems / To do
# ================================
# - Hook up volumes
# - Hook up some database
#	- make this use volumes too
#
#

FROM ubuntu:latest
 
MAINTAINER David Reyes "david@thoughtbubble.ca"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y curl git nano vim && \
	apt-get install -y build-essential libssl-dev


# Add PPA to get our desired version version of Node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs


# Permissions fixing for npm / angular
# workaround for issue https://github.com/angular/angular-cli/issues/7389
RUN groupadd --gid 1001 node && \
	useradd --uid 1001 --gid node --shell /bin/bash --create-home node
USER node
RUN mkdir /home/node/.npm-global
ENV PATH /home/node/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX /home/node/.npm-global


RUN npm install -g typescript tslint
RUN npm install -g @angular/cli


WORKDIR /home/node/
RUN ng new temp
WORKDIR /home/node/temp
RUN npm install
RUN npm install --save-dev @angular/cli@latest


# RUN mkdir /home/node/app
# RUN git clone --depth=1 https://github.com/angular/quickstart.git /home/node/app
# WORKDIR /home/node/app

#RUN npm install
#RUN npm install --save-dev @angular/cli@latest

COPY entrypoint.sh /home/node/
# Remove pesky Windows carriage-returns
RUN sed -i -e 's/\r$//' /home/node/entrypoint.sh

EXPOSE 3000

# ENTRYPOINT ["/home/node/entrypoint.sh"]

CMD ["ng", "serve", "--host=0.0.0.0", "--port=3000"]
