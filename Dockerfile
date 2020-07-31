FROM seapy/rails-nginx-unicorn-pro:v1.1-ruby2.3.0-nginx1.8.1
RUN apt update && apt upgrade -y
RUN curl -sL https://deb.nodesource.com/setup_14.x
RUN apt-get install -y nodejs
ADD ./app/Gemfile /app/Gemfile
ADD ./app/Gemfile.lock /app/Gemfile.lock
RUN apt-get install -y libpq-dev
RUN apt-get install -y imagemagick libmagickwand-dev
RUN bundle install --without development test
ADD ./app/ /app

EXPOSE 80
