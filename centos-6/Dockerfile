FROM centos:6
MAINTAINER Xabier de Zuazo "xabier@zuazo.org"

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/chef/bin:/opt/chef/embedded/bin \
    LANG=en_US.UTF-8 \
    CHEF_VERSION=12.4.1 \
    CHEF_REPO_PATH=/tmp/chef
ENV COOKBOOK_PATH=$CHEF_REPO_PATH/cookbooks

# Install chef-client
RUN curl -L https://www.chef.io/chef/install.sh | bash -s -- -v $CHEF_VERSION

# Install some required packages for gem compilation
RUN yum install -y \
      autoconf \
      gcc \
      gcc-c++ \
      make \
      tar && \
    yum clean all

# Install berkshelf inside chef
RUN /opt/chef/embedded/bin/gem install berkshelf --no-ri --no-rdoc --verbose

# Configure Chef Client
RUN mkdir -p $COOKBOOK_PATH && \
    mkdir -p /etc/chef ~/.chef && \
    echo "cookbook_path %w($COOKBOOK_PATH)" > /etc/chef/client.rb && \
    echo "local_mode true" >> /etc/chef/client.rb && \
    echo "chef_zero.enabled true" >> /etc/chef/client.rb && \
    ln /etc/chef/client.rb ~/.chef/config.rb

# Some optional but recommended packages
RUN yum install -y \
      git && \
    yum clean all

# Clean and remove not required packages
RUN yum remove -y \
      autoconf \
      gcc \
      gcc-c++ \
      tar && \
    yum clean all

CMD ["bash"]
