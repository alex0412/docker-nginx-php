FROM nginx

MAINTAINER Alexander Li <a.li@playboy.de>

RUN rm /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/

RUN \
  apt-get update && apt-get -y install apt-utils && \
  apt-get -y install wget && \
  apt-get -y install imagemagick && \
  wget http://pear.php.net/go-pear.phar && \
  apt-get -y install vim && \

# Install PHP, MySQL Client, Curl
  apt-get -y install php5-cli php5-fpm php5-pgsql php5-gd php5-imagick php5-curl php5-mysqlnd php5-xdebug php5-dev curl mysql-client && \

# Various
  php go-pear.phar && \
  pecl install -f xhprof && \

# PHP Settings
  echo "listen.mode = 0666" >> /etc/php5/fpm/pool.d/www.conf && echo "clear_env = no" >> /etc/php5/fpm/pool.d/www.conf && \
  echo "date.timezone = Europe/Berlin" >> /etc/php5/cli/php.ini && echo "date.timezone = Europe/Berlin" >> /etc/php5/fpm/php.ini && \
  echo "clear_env = no" >> /etc/php5/fpm/pool.d/www.conf && \
  sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php5/fpm/php.ini && \
  #echo "extension=xhprof.so" >> /etc/php5/fpm/php.ini && \

# Install Supervisor to start processes
  apt-get install -y supervisor && \
  mkdir -p /var/log/supervisor && \

# Install Composer and Drush
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  composer global require drush/drush:dev-master && \
  echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc && \

# Install Node
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

RUN rm /etc/php5/mods-available/xdebug.ini
ADD xdebug.ini /etc/php5/mods-available/

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
