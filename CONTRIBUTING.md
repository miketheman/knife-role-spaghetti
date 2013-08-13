Contributing
============

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Test your changes (`rake test`)
1. Commit your changes (`git commit -am 'Added some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

Notes
-----
- Ensure you have a current version of my `master` branch before branching, this keeps things clean.
- Restrict whitespace changes to their own commits.
- Use the [Appraisals][(https://github.com/thoughtbot/appraisal) task `rake apparaisal` to test for dependency compatibility.
  Travis does this for us, but it's always nice to test prior to committing.
- Do not increase complexity beyond what it already is. In fact, attempt to reduce it.
