FROM alpine

RUN apk update

RUN apk add --no-cache shadow ruby less bash git php7-tokenizer php7-mbstring php7-json php7-phar php7-gd php7-mysqli php7-zlib php7-curl php7-cli openssh-client file ruby-dev wget jq  py-pip g++ make

#ruby and puppet
RUN gem update --system --no-rdoc --no-ri
COPY Gemfile /root/Gemfile
RUN bundle install --gemfile=/root/Gemfile
RUN gem update --system

#install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
COPY composer.json /
RUN php composer.phar install

#python part
RUN pip install -U setuptools
RUN pip install -U pylint

#copy over all testfiles
COPY testfiles/ /root/testfiles/

#these tests are not needed but provide a way to test this docker file and see that all dependencies are met
RUN php -l /root/testfiles/test.php
RUN puppet parser validate /root/testfiles/test.pp
RUN ruby -c /root/testfiles/test.rb
RUN ruby -c /root/testfiles/test.rb
RUN erb -P -x -T '-' /root/testfiles/test.erb | ruby -c
RUN pylint /root/testfiles/test.py

#code style problem seekers:
RUN php /vendor/friendsofphp/php-cs-fixer/php-cs-fixer fix --dry-run --diff /root/testfiles/*.php

#remove all unneeded stuff
RUN rm -rf /root/testfiles

#added for debug
#ENTRYPOINT ["/usr/bin/env"]
#COPY run.sh /bin/run.sh
#CMD ["/bin/run.sh"]