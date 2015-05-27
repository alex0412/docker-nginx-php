FROM nginx

MAINTAINER Alexander Li <a.li@playboy.de>

RUN rm /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/

# Install PHP
RUN \
  apt-get update && apt-get -y install apt-utils && \
  echo "deb http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list && \
  echo "deb-src http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list && \
  apt-get -y install wget && wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg && \
  apt-get -y install php5-cli php5-fpm php5-pgsql php5-gd php5-curl curl && \

  echo "listen.mode = 0666" >> /etc/php5/fpm/pool.d/www.conf && echo "clear_env = no" >> /etc/php5/fpm/pool.d/www.conf && \
  echo "date.timezone = Europe/Berlin" >> /etc/php5/cli/php.ini && echo "date.timezone = Europe/Berlin" >> /etc/php5/fpm/php.ini && \

# Install Supervisor to start processes
  apt-get install -y supervisor && \
  mkdir -p /var/log/supervisor && \

# Get Composer
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  composer global require drush/drush:dev-master && \
  echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc && \

# Install Ruby and Node
  apt-get update && apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/* && \

  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#WORKDIR /app
#ONBUILD ADD . /app

CMD ["/usr/bin/supervisord"]
