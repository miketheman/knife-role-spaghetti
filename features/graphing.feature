Feature: Graphing role dependencies works
  In order to map out role dependencies to a graph
  As a Chef
  I want to run the plugin against a roles directory

Background:
  Given I double `dot`
  And I double `neato`

Scenario: Running against a knife.rb with undefined roles directory should fail
  Given an empty file named ".chef/knife.rb"
  When I run `knife role spaghetti`
  Then the output should contain exactly:
  """
  FATAL: No roles were found in role_path: /var/chef/roles
  FATAL: Ensure that your knife.rb has the correct path.
  
  """
  And the exit status should be 1

Scenario: Running against a directory with multiple roles succeeds
  Given a file named ".chef/knife.rb" with:
  """
  role_path "#{File.dirname(__FILE__)}/../roles"
  """
  And a file named "roles/webserver.rb" with:
  """
  name "webserver"
  description "Simple Web App"
  run_list(
    "recipe[apache2]"
  )
  """
  And a file named "roles/database.rb" with:
  """
  name "database"
  description "Some database"
  run_list(
    "recipe[mysql]"
  )
  """
  And a file named "roles/base.json" with:
  """
  {
    "name" : "base",
    "description" : "Sample base json role",
    "run_list" : [
      "recipe[yum]",
      "recipe[apt]",
      "recipe[ntp]"
    ]
  }
  """
  When I successfully run `knife role spaghetti multirole.png`
  Then the exit status should be 0

Scenario: Running against embedded roles succeeds
  Given a file named ".chef/knife.rb" with:
  """
  role_path "#{File.dirname(__FILE__)}/../roles"
  """
  And a file named "roles/webserver.rb" with:
  """
  name "webserver"
  description "Simple Web App"
  run_list(
    "recipe[apache2]"
  )
  """
  And a file named "roles/database.rb" with:
  """
  name "database"
  description "Some database"
  run_list(
    "recipe[mysql]"
  )
  """
  And a file named "roles/appstack.rb" with:
  """
  name "appstack"
  description "Application stack"
  run_list(
    "role[database]",
    "role[webserver]"
  )
  """
  When I successfully run `knife role spaghetti embedded.png`
  Then the exit status should be 0

Scenario: Running against only json role files succeeds.
  Given a file named ".chef/knife.rb" with:
  """
  role_path "#{File.dirname(__FILE__)}/../roles"
  """
  And a file named "roles/webserver.json" with:
  """
  {
    "name": "webserver",
    "chef_type": "role",
    "json_class": "Chef::Role",
    "default_attributes": {
      "apache2": {
        "listen_ports": [
          "80",
          "443"
        ]
      }
    },
    "description": "The base role for systems that serve HTTP traffic",
    "run_list": [
      "recipe[apache2]",
      "recipe[apache2::mod_ssl]",
      "role[monitor]"
    ],
    "env_run_lists" : {
     },
    "override_attributes": {
      "apache2": {
        "max_children": "50"
      }
    }
  }
  """
  When I successfully run `knife role spaghetti webserver.png`
  Then the exit status should be 0
