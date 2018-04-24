# Create container for Ruby
FROM oniram88/docker-rails_5:mysql

RUN mkdir -p /usr/share/www
WORKDIR /usr/share/www
 
# Check to see if server.pid already exists. If so, delete it.
RUN test -f tmp/pids/server.pid && rm -f tmp/pids/server.pid; true
ADD Gemfile .
ADD Gemfile.lock .
 
# Bundle
RUN bundle install --full-index
 