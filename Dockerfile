#
# Ghost Dockerfile
#
# https://github.com/dockerfile/ghost
#

# Pull base image.
FROM dockerfile/nodejs

# Install Ghost
RUN \
  cd /tmp && \
  wget -O stable.zip https://github.com/paulshi/Ghost/archive/fec78ec7649770b81e4fc2e8c5e0adf24a4c5054.zip && \
  unzip stable.zip && \
  rm -f stable.zip && \
  mv Ghost-fec78ec7649770b81e4fc2e8c5e0adf24a4c5054 /ghost && \
  cd /ghost && \
  npm install -g grunt-cli && \
  npm install && \
  grunt init && \
  grunt prod && \
  npm install --production && \
  sed 's/127.0.0.1/0.0.0.0/' /ghost/config.example.js > /ghost/config.js && \
  useradd ghost --home /ghost

# Add files.
ADD start.bash /ghost-start

# Set environment variables.
ENV NODE_ENV production

# Define mountable directories.
VOLUME ["/data", "/ghost-override"]

# Define working directory.
WORKDIR /ghost

# Define default command.
CMD ["bash", "/ghost-start"]

# Expose ports.
EXPOSE 2368
