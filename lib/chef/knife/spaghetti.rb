require 'chef/knife'

module KnifeRoleSpaghetti
  class RoleSpaghetti < Chef::Knife

    deps do
      require 'chef/role'
      require 'graphviz'
    end

    banner "knife role spaghetti [ OUTFILE.PNG -G FORMAT [-N] ]"

    option :graphformat,
      :short => "-G FORMAT",
      :long => "--graph-format FORMAT",
      :default => "png",
      :boolean => false,
      :description => "Format for dependency graph output [png|dot]"

    option :neatograph,
      :short => "-N",
      :long => "--neato-graph",
      :boolean => true,
      :description => "Specify to render the graph in the neato engine"

    def run

      self.config = Chef::Config.merge!(config)

      # OPTIMIZE: Maybe instead of a flag, infer the graph format from fileext?

      # Parse the configuration options, provide defaults where needed      
      if config[:graphformat]
        output_format = config[:graphformat].to_sym
      else
        output_format = :png
      end

      # Determine of a filename has been passed
      if @name_args.size >= 1
        filename = @name_args[0]
      else
        filename = "role-spaghetti.#{output_format}"
      end

      # If we can't find any roles, it's pointless to continue.
      if Dir.glob(File.join(Chef::Config.role_path, '*.rb')).size == 0
        ui.fatal("No roles were found in role_path: #{config[:role_path]}")
        ui.fatal("Ensure that your knife.rb has the correct path.")
        exit 1
      end

      g = GraphViz.new(:RoleDependencies, :type => :digraph,
        :fontname => "Verdana", :fontsize => 20,
        :label => "\n\n\nChef Role Dependencies\n",
        :rankdir => "LR",
        :overlap => "false",
        :compound => "true"
      )

      # OPTIMIZE: Handle json files too
      Dir.glob(File.join(Chef::Config.role_path, '*.rb')) do |rb_file|
        role = Chef::Role.new
        role.from_file(rb_file)
        # OPTIMIZE: Handle environment run_lists

        g.node[:shape] = "box"
        g.node[:style] = "rounded"
        g.node[:color] = "red"
        role_node = g.add_nodes("#{role.name}_role", :label => role.name)

        # This logic is to ensure that an embedded role doesn't change color
        role.run_list.each do |rli|

          if rli.role?
            g.node[:shape] = "box"
            g.node[:style] = "rounded"
            g.node[:color] = "red"
          else
            g.node[:shape] = "component"
            g.node[:color] = "blue"
          end

          rli_node = g.add_nodes(rli.name)
          g.add_edges(role_node, rli_node)
        end

      end

      # Let's write out the graph to a file
      if config[:neatograph]
        g.output(output_format => "#{filename}", :use => "neato")
      else
        # default to dot
        g.output(output_format => "#{filename}")
      end

      ui.msg("A Role dependency graph has been written to #{filename}")
    end #run end
  end #class end
end #module end
