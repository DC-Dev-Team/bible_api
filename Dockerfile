# Use the Passenger Ruby base image
FROM phusion/passenger-ruby27:2.6.3

# Set correct environment variables
ENV HOME /root
WORKDIR /home/app/webapp

# Install dependencies for SQLite3
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    sqlite3 \
    nodejs

# Copy the app code to the container
COPY . /home/app/webapp

# Set the correct permissions for Passenger
RUN chown -R app:app /home/app/webapp

# Install Bundler and required gems
RUN gem install bundler
RUN bundle install --deployment --without development test

# Clean up apt-get caches to reduce the image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the port that Passenger will listen to
EXPOSE 3000

# Start the Passenger app server
CMD ["/sbin/my_init"]
