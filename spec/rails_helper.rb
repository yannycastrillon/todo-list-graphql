# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'database_cleaner'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
   with.test_framework :rspec
   with.library :rails
 end
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

RSpec.configuration do |config|
  # set up factory bot
  config.include FactoryBot::Syntax::Methods

  # set up database cleaner
  #start by truncating all the tables but then use the faster transaction strategy the rest of the time.
 config.before(:suite) do
   DatabaseCleaner.clean_with(:truncation)
   DatabaseCleaner.strategy = :transaction
 end

 # start the transaction strategy as examples are run
 config.around(:each) do |example|
   DatabaseCleaner.cleaning do
     example.run
   end
 end

 # [...]
end
