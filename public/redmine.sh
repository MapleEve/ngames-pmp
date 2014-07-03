#!/bin/bash
cd /var/www/redmine/
bundle install --without development test
rake tmp:cache:clear
rake tmp:sessions:clear
rake redmine:plugins:migrate RAILS_ENV=production
service httpd restart


