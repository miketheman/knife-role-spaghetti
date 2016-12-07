require 'chef/knife'

module KnifeRoleSpaghetti
  # RoleSpaghetti is a Chef::Knife plugin
  # It creates a new class, which is visibile when running the `knife` cli tool
  # and provides a way to output a visualized dependency graph of Chef Roles.
  class RoleSpaghetti < Chef::Knife
    deps do
      require 'chef/role'
      require 'chef/knife/core/object_loader'
      require 'graphviz'
    end

    banner 'knife role spaghetti [ OUTFILE.PNG -G FORMAT [-N] ]'

    option :graphformat,
           short: '-G FORMAT',
           long: '--graph-format FORMAT',
           default: 'png',
           boolean: false,
           description: 'Format for dependency graph output [png|dot]'

    option :neatograph,
           short: '-N',
           long: '--neato-graph',
           boolean: true,
           description: 'Specify to render the graph in the neato engine'

    # OPTIMIZE: Add an option to display cookbooks instead of recipes?

    def loader
      @loader ||= Chef::Knife::Core::ObjectLoader.new(Chef::Role, ui)
    end

    def run
      self.config = Chef::Config.merge!(config)

      # OPTIMIZE: Maybe instead of a flag, infer the graph format from fileext?

      # Parse the configuration options, provide defaults where needed
      if config[:graphformat]
        output_format = config[:graphformat].to_sym
      else
        output_format = :png
      end
      Chef::Log.debug("Output format is: #{output_format}")

      # Determine of a filename has been passed
      if @name_args.size >= 1
        filename = @name_args[0]
      else
        filename = "role-spaghetti.#{output_format}"
      end
      Chef::Log.debug("Output filename is: #{filename}")

      loaded_roles = loader.find_all_objects(config[:role_path][0])

      # If we can't find any roles, it's pointless to continue.
      if loaded_roles.size == 0
        ui.fatal("No roles were found in role_path: #{config[:role_path][0]}")
        ui.fatal('Ensure that your knife.rb has the correct path.')
        exit 1
      end

      g = GraphViz.new(:RoleDependencies, type: :digraph,
                                          fontname: 'Verdana', fontsize: 20,
                                          label: "\n\n\nChef Role Dependencies\n",
                                          rankdir: 'LR',
                                          overlap: 'false',
                                          compound: 'true'
      )

      loaded_roles.each do |role_file|
        # Create an absolute path, since some file references include relative paths
        abspath = File.absolute_path(File.join(config[:role_path][0], role_file))

        # The object_from_file method figures out the ruby/json logic
        role = loader.object_from_file(abspath)

        Chef::Log.debug("Loaded role is: #{role}")

        # OPTIMIZE: Handle environment run_lists

        g.node[:shape] = 'box'
        g.node[:style] = 'rounded'
        g.node[:color] = 'red'
        role_node = g.add_nodes("#{role.name}_role", label: role.name)

        # This logic is to ensure that an embedded role doesn't change color
        role.run_list.each do |rli|

          if rli.role?
            g.node[:shape] = 'box'
            g.node[:style] = 'rounded'
            g.node[:color] = 'red'
            rli_node = g.add_nodes("#{rli.name}_role", label: rli.name)
          else
            g.node[:shape] = 'component'
            g.node[:color] = 'blue'
            rli_node = g.add_nodes(rli.name)
          end

          g.add_edges(role_node, rli_node)
        end

      end

      # Let's write out the graph to a file
      if config[:neatograph]
        g.output(output_format => "#{filename}", :use => 'neato')
      else
        # default to dot
        g.output(output_format => "#{filename}")
      end

      ui.msg("A Role dependency graph has been written to #{filename}")
    end # run end
  end # class end
end # module end
