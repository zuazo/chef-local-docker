# Installs Apache httpd daemon using the apache2 cookbook from Supermarket

FROM zuazo/chef-local:debian7
# MAINTAINER Xabier de Zuazo "xabier@zuazo.org"

COPY . /tmp/apache2
RUN berks vendor -b /tmp/apache2/Berksfile $COOKBOOK_PATH
RUN chef-client -r "recipe[apache2]"

CMD ["apache2", "-D", "FOREGROUND"]
