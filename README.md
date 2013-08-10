# knife-role-spaghetti
[![Gem Version](https://badge.fury.io/rb/knife-role-spaghetti.png)](http://badge.fury.io/rb/knife-role-spaghetti)
[![Dependency Status](https://gemnasium.com/miketheman/knife-role-spaghetti.png)](https://gemnasium.com/miketheman/knife-role-spaghetti)
[![Build Status](https://secure.travis-ci.org/miketheman/knife-role-spaghetti.png?branch=master)](http://travis-ci.org/miketheman/knife-role-spaghetti)
[![BuildHeroes](https://www.buildheroes.com/projects/knife-role-spaghetti.png)](https://www.buildheroes.com/projects/knife-role-spaghetti)
[![Code Climate](https://codeclimate.com/github/miketheman/knife-role-spaghetti.png)](https://codeclimate.com/github/miketheman/knife-role-spaghetti)

Knife plugin for [Chef][chef] to draw dependency graphs for roles that have become spaghetti.

## Installation

#### Requirements

Ruby 1.9.2 and higher.

This plugin requires on [Graphviz][graphviz], and should be installed prior to
installing the plugin.

Graphviz may be obtained through a variety of methods. On OSX an easy method is
via [Homebrew][homebrew]:

    $ brew install graphviz

### Gem install, via RubyGems:

    $ gem install knife-role-spaghetti

## Usage

**NOTE:** Ensure that your `knife.rb` has the `role_path` setting configured.

Since this is a [Knife][knife] plugin, execution should be performed in your Chef repository.

Execute:

    $ knife role spaghetti

with no arguments should result in a new file named `role-spaghetti.png` in your
repo root.

    $ knife role spaghetti "/tmp/someotherfilename.png"

will place the file in the specified location.

Execute `knife role spaghetti -h` for more options.

## Examples
From a [sample role][sample role jt], courtesy of @jtimberman, along with one from the [Opscode Wiki][sample role wiki], plus one more cyclic role model, produces this image:

![Sample Roles][sample roles]

(full resolution [here](http://cl.ly/image/1C0Q3p0y093s))

Running through the neato renderer (with the `-N` switch) produces this image:

![Sample Roles Neato][sample roles neato]

(full resolution [here](http://cl.ly/image/2s340G0x3d33))

[chef]: http://www.opscode.com/chef/
[graphviz]: http://www.graphviz.org/
[homebrew]: http://mxcl.github.com/homebrew/
[knife]: http://wiki.opscode.com/display/chef/Knife
[miketheman]: https://github.com/miketheman
[sample role jt]: https://gist.github.com/858903
[sample role wiki]: http://wiki.opscode.com/display/chef/Roles#Roles-TheRubyDSL
[sample roles]: http://f.cl.ly/items/0w3r0k1I291g3x230m3y/rsz_sample-roles.png "Sample Roles"
[sample roles neato]: http://f.cl.ly/items/370L0z3L2U0l341Q0f2k/rsz_sample-roles-neato.png "Sample Roles - neato"

## License

Author:: [Mike Fiedler][miketheman] (<miketheman@gmail.com>) [![endorse](http://api.coderwall.com/miketheman/endorsecount.png)](http://coderwall.com/miketheman)
Copyright:: Copyright (c) 2012-2013 Mike Fiedler
License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
