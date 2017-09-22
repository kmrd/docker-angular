#
#
# Ubuntu-based, Angular container
#
# Ubuntu 16.04
# Node 8.x
#
# - Uses Bind mounts for working on code on your local host machine
#
#
# Usage
# ================================
# Retrieving Image:
# --------------------------------
# docker pull kmrd/ng
#
#
# Starting the Container:
# --------------------------------
# (Run inside your development directory)
# docker run -it --rm --name ngdev -p 4200:4200 --mount type=bind,source=$(PWD),target=/home/node/app kmrd/ng
#
#
# Can use the following for persistant DB store, etc:
# 	"docker volume create devngvol"	# creates a volume named devngvol
#	--mount source=devngvol,target=/dir/in/container #use this as a 'docker run' parameter
#
#
# Building Image:
# --------------------------------
# docker build -t kmrd/ng .
#
#
# Dev Notes
# ================================
# - Consider using alpine rather than ubuntu since it's more lightweight
# 
#
# Known Problems / To do
# ================================
# - Hook up some database using volumes?
# - Testing needed on OSX
#
#

FROM ubuntu:16.04
 
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


# Useful to set a predefined project
# WORKDIR /home/node/
# RUN ng new www --directory /home/node/app
# WORKDIR /home/node/app
# RUN npm install
# RUN npm install --save-dev @angular/cli@latest

# Use entrypoint rather than CMD for additional commands
# COPY entrypoint.sh /home/node/
# # Remove pesky Windows carriage-returns
# RUN sed -i -e 's/\r$//' /home/node/entrypoint.sh
# ENTRYPOINT ["/home/node/entrypoint.sh"]

EXPOSE 4200

# CMD ["ng", "serve", "--host=0.0.0.0", "--port=4200"]
CMD ["/bin/bash"]
