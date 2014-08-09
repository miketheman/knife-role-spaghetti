# Set up the environment for testing
require 'aruba/cucumber'
require 'aruba-doubles/cucumber'

Before do
  @aruba_timeout_seconds = 5

  # Set the env var PWD to aruba's working directory, instead of inheriting
  # the main process's PWD. See CHEF-3663 for why this changed in Chef 11.
  ENV['PWD'] = File.expand_path current_dir
end

After do |s|
  # Tell Cucumber to quit after this scenario is done - if it failed.
  # This is useful to inspect the 'tmp/aruba' directory before any other
  # steps are executed and clear it out.
  Cucumber.wants_to_quit = true if s.failed?
end
