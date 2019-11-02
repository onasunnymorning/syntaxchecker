FROM alpine

RUN apk update

RUN apk add --no-cache shadow ruby less bash git php7-gd php7-mysqli php7-zlib php7-curl php7-cli openssh-client file ruby-dev build-base wget cmake boost-dev make curl git curl-dev ruby ruby-dev gcc g++ yaml-cpp-dev jq openjdk8

RUN gem update --system --no-rdoc --no-ri
RUN gem install bundler --no-rdoc --no-ri
COPY Gemfile /root/Gemfile
RUN bundle install --gemfile=/root/Gemfile
RUN gem update --system --no-rdoc --no-ri 

#php code syntax
RUN wget https://cs.symfony.com/download/php-cs-fixer-v2.phar -O php-cs-fixer
RUN chmod a+x php-cs-fixer
RUN mv php-cs-fixer /usr/local/bin/php-cs-fixer