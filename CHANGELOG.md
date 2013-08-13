Changelog
=========

# 0.0.5 / 2013-08-13
* Cleaned up documentation layouts - Changelog, Contributing, Readme.
* Updated dependencies, moved some out of gemspec to Gemfile
* Using new dependency testing method, removes constraint on Chef version 10

# 0.0.4 / 2012-12-24
* Allows for better Chef version dependency management, thanks @patcon!
* Better Travis testing: more Chef versions, better timeout handling
* Locked down a bunch of gem dependencies
* Updated minimum required ruby to 1.9.2

# 0.0.3 / 2012-08-04
* Fixed JSON roles loading #7 - Thanks @miah & @tezz!
* Re-implemented the DRY proposed by @jtimberman in #1, with a different method
* Prevent a role and recipe sharing the same name from colliding
* Figured out correct testing requirements matrix for Travis
* Added some more verbose logging options

# 0.0.2 / 2012-07-21
* Updated CLI banner to reflect that filename is not required, renamed for clarity
* Improved handling cases where a role contains recipes named the same as the role
* Added handling for roles in JSON format

# 0.0.1 / 2012-07-20
* Initial commit
