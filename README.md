# chef-local Docker Container
[![Source Code](https://img.shields.io/badge/source-GitHub-blue.svg?style=flat)](https://github.com/zuazo/chef-local-docker)&nbsp;
[![Docker Repository on Quay.io](https://quay.io/repository/zuazo/chef-local/status "Docker Repository on Quay.io")](https://quay.io/repository/zuazo/chef-local)&nbsp;
[![Build Status](http://img.shields.io/travis/zuazo/chef-local-docker.svg?style=flat)](https://travis-ci.org/zuazo/chef-local-docker)

[Docker](https://www.docker.com/) images with [Chef](https://www.chef.io/) configured to make it easier to run cookbooks using chef in local mode (with *chef-zero*).

The images come with Chef `12` installed, also include Berkshelf and git.

## Installation

    $ docker pull zuazo/chef-local:debian-7

## Supported Tags

* `centos-6`: A CentOS 6 image.
* `centos-7`: A CentOS 7 image.
* `centos-7-systemd`: A CentOS 7 image with systemd (requires `--privileged`).
* `debian-6`: A Debian Squeeze image.
* `debian-7`: A Debian Wheezy image.
* `debian-8`: A Debian Jessie image.
* `fedora-20`: A Fedora Heissenbug image.
* `fedora-22`: A Fedora 22 image.
* `fedora-rawhide-systemd`: A [Fedora Rawhide](https://fedoraproject.org/wiki/Releases/Rawhide) image (requires `--privileged`).
* `ubuntu-12.04`: An Ubuntu Precise Pangolin **LTS** image.
* `ubuntu-12.04-upstart`: An Ubuntu Precise Pangolin **LTS** image with Upstart.
* `ubuntu-14.04`: An Ubuntu Trusty Tahr **LTS** image.
* `ubuntu-14.04-upstart`: An Ubuntu Trusty Tahr **LTS** image with Upstart.
* `ubuntu-15.04`: An Ubuntu Vivid Vervet image.

## Usage

### Running a Cookbook from the Current Directory

You can include the following *Dockerfile* in your cookbooks to run them inside a Docker container:

```Dockerfile
FROM zuazo/chef-local:debian-7

# Copy the cookbook from the current working directory:
COPY . /tmp/mycookbook
# Download and install the cookbook and its dependencies in the cookbook path:
RUN berks vendor -b /tmp/mycookbook/Berksfile $COOKBOOK_PATH
# Run Chef Client, runs in local mode by default:
RUN chef-client -r "recipe[apt],recipe[mycookbook]"

# CMD to run you application
```

Now you can create a Docker image and run your application:

    $ docker build -t mycookbook .
    $ docker run -d mycookbook bash

The cookbook must have a *Berksfile* for this to work. You can use `$ berks init .` to generate a *Berksfile*. See the [Berkshelf](http://berkshelf.com/) documentation for more information.

### Running a Cookbook from GitHub

For example, you can user the following *Dockerfile* to install Nginx:

```Dockerfile
FROM zuazo/chef-local:debian-7

RUN git clone https://github.com/miketheman/nginx.git /tmp/nginx
RUN berks vendor -b /tmp/nginx/Berksfile $COOKBOOK_PATH
RUN chef-client -r "recipe[apt],recipe[nginx]"

CMD ["nginx", "-g", "daemon off;"]
```

Then you can build your image and start your Nginx server:

    $ docker build -t chef-nginx .
    $ docker run -d -p 8080:80 chef-nginx

Now you can go to [http://localhost:8080](http://localhost:8080) to see your gorgeous web server.

### Running Cookbooks from a Berksfile

You can use a *Berksfile* to run cookbooks if you prefer.

For example, using the following *Berksfile*:

```ruby
source 'https://supermarket.chef.io'

cookbook 'apache2'
# cookbook ...
```

With the following *Dockerfile*:

```Dockerfile
FROM zuazo/chef-local:debian-7

COPY Berksfile /tmp/Berksfile
RUN berks vendor -b /tmp/Berksfile $COOKBOOK_PATH
RUN chef-client -r "recipe[apache2]"
```

Then you can build your image and start your apache2 server installed with Chef:

    $ docker build -t chef-apache2 .
    $ docker run -d -p 8088:80 chef-apache2

Now you can go to [http://localhost:8088](http://localhost:8088) to see your web server.

### Changing Chef Cookbook Attribute Values

You can add the Node attributes to change in a JSON file:

```json
{
  "java": {
    "jdk_version": "7"
  }
}
```

Then run `chef-client` with the `-j` option pointing to the JSON file:

```Dockerfile
FROM zuazo/chef-local:debian-7

COPY Berksfile /tmp/java/Berksfile
COPY attributes.json /tmp/attributes.json
RUN berks vendor -b /tmp/java/Berksfile $COOKBOOK_PATH
RUN chef-client -j /tmp/attributes.json -r "recipe[java]"

ENTRYPOINT ["java"]
CMD ["-version"]
```

Build the image and run it:

    $ docker build -t chef-java .
    $ docker run chef-java
    java version "1.7.0_79"
    OpenJDK Runtime Environment (IcedTea 2.5.5) (7u79-2.5.5-1~deb7u1)
    OpenJDK 64-Bit Server VM (build 24.79-b02, mixed mode)

### Using Systemd Images

You need to create a *Dockerfile* similar to the following:

```Dockerfile
FROM zuazo/chef-local:centos-7-systemd

# Install your application here:
# [...]

# Start systemd:
CMD ["/usr/sbin/init"]
```

Then, you can build the image and run it in privileged mode:

  $ docker build -t local/c7-systemd-myapp .
  $ docker run --privileged -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 local/c7-systemd-myapp

### More Examples

See the [*examples/*](https://github.com/zuazo/chef-local-docker/tree/master/examples) directory.

## Build from Sources

Instead of installing the image from Docker Hub, you can build the images from sources if you prefer:

    $ git clone https://github.com/zuazo/chef-local-docker chef-local
    $ cd chef-local/debian-7
    $ docker build -t zuazo/chef-local:debian-7 .

## Defined Environment Variables

* `COOKBOOK_PATH`: Directory where the cookbooks should be copied
  (`/tmp/chef/cookbooks`).
* `CHEF_REPO_PATH`: Chef main repository path (`/tmp/chef`).

# License and Author

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@zuazo.org>)
| **Copyright:**       | Copyright (c) 2015
| **License:**         | Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
