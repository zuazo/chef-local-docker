FROM ubuntu:12.04
MAINTAINER Xabier de Zuazo "xabier@zuazo.org"

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/chef/bin:/opt/chef/embedded/bin \
    APT_ARGS="-y --no-install-recommends --no-upgrade" \
    CHEF_VERSION=12.4.1 \
    CHEF_REPO_PATH=/tmp/chef
ENV COOKBOOK_PATH=$CHEF_REPO_PATH/cookbooks

# Install chef-client
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install $APT_ARGS \
      ca-certificates \
      curl && \
    curl -L https://www.chef.io/chef/install.sh | bash -s -- -v $CHEF_VERSION

# Install some required packages for gem compilation
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install $APT_ARGS \
      autoconf \
      g++ \
      gcc \
      make

# Install berkshelf inside chef
RUN /opt/chef/embedded/bin/gem install berkshelf --no-ri --no-rdoc --verbose

# Install berkshelf in the system (+40 MB)
# RUN DEBIAN_FRONTEND=noninteractive \
#     apt-get install $APT_ARGS \
#       ruby \
#       ruby-dev && \
#     gem install berkshelf --no-ri --no-rdoc

# Configure locales
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install $APT_ARGS \
      locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Configure Chef Client
RUN mkdir -p $COOKBOOK_PATH && \
    mkdir -p /etc/chef ~/.chef && \
    echo "cookbook_path %w($COOKBOOK_PATH)" > /etc/chef/client.rb && \
    echo "local_mode true" >> /etc/chef/client.rb && \
    echo "chef_zero.enabled true" >> /etc/chef/client.rb && \
    ln /etc/chef/client.rb ~/.chef/config.rb

# Some optional but recommended packages (+33 MB)
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install $APT_ARGS \
       git

# Clean and remove not required packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get remove -y --purge \
      autoconf \
      g++ \
      gcc \
      make \
      curl && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get autoremove -y && \
    rm -rf /var/cache/apt/archives/*

CMD ["bash"]
