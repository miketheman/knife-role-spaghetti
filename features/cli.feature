Feature: Ensure that the Command Line Interface works as designed
  In order to create role graphs via CLI
  As a Chef
  I want to run the CLI with different arguments

Background:
  Given a file named ".chef/knife.rb" with:
  """
  role_path ["#{File.dirname(__FILE__)}/../roles"]
  """
  And a file named "roles/webserver.rb" with:
  """
  name "webserver"
  description "Simple Web App"
  run_list(
    "recipe[apache2]"
  )
  """
  And I double `dot`
  And I double `neato`

Scenario Outline: Running with Help flags produces the correct result
  When I run `knife role spaghetti <HelpFlag>`
  Then the output should contain:
  """
  knife role spaghetti [ OUTFILE.PNG -G FORMAT [-N] ]
  """
  And the exit status should be 1
  Examples:
    | HelpFlag |
    | -h       |
    | --help   |

Scenario: Running with no arguments produces the correct result
  When I successfully run `knife role spaghetti`
  Then the exit status should be 0

Scenario: Running with a filename succeeds
  When I successfully run `knife role spaghetti webserver.png`
  Then the exit status should be 0

Scenario Outline: Running with different flags succeeds
  When I successfully run `knife role spaghetti <Filename> <Flag> <Format>`
  Then the exit status should be 0
  Examples:
    | Filename              | Flag           | Format |
    | "webserver-short.png" | -G             | png    |
    | "webserver-long.png"  | --graph-format | png    |
    | "webserver-short.dot" | -G             | dot    |
    | "webserver-long.dot"  | --graph-format | dot    |

Scenario Outline: Running with neato switch succeeds
  When I successfully run `knife role spaghetti <Filename> <Flag>`
  Then the exit status should be 0
  Examples:
    | Filename                    | Flag          |
    | "webserver-short-neato.png" | -N            |
    | "webserver-long-neato.png"  | --neato-graph |

Scenario: Running with no filename, the format flag and no format, should fail
  When I run `knife role spaghetti -G`
  Then the exit status should be 1

Scenario: Running with no filename, the format flag and no format, should fail
  When I run `knife role spaghetti failfile.png -G`
  Then the exit status should be 1

Scenario: Running with verbose flags provides better output
  When I successfully run `knife role spaghetti verbose.png -VV`
  Then the output should contain:
  """
  DEBUG: Output format is: png
  DEBUG: Output filename is: verbose.png
  DEBUG: Loaded role is: role[webserver]
  A Role dependency graph has been written to verbose.png
  """
