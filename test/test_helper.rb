# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __dir__)
require "rails/test_help"

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

# Custom Test Helpers
require 'support/effective_email_templates_test_builder'
require 'support/effective_email_templates_test_helper'
require 'pry-byebug'

class ActiveSupport::TestCase
  include Warden::Test::Helpers

  # For stub_any_instance
  include EffectiveTestBot::DSL

  include EffectiveEmailTemplatesTestBuilder
  include EffectiveEmailTemplatesTestHelper
end

# Load the seeds
load "#{__dir__}/../db/seeds.rb"

# Load the email templates
require 'effective_email_templates/importer'
EffectiveEmailTemplates::Importer.overwrite(quiet: true)
