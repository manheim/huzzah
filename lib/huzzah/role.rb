module Huzzah
  class Role
    include FileLoader
    include SiteBuilder

    attr_accessor :role_data, :driver, :browser

    def initialize(name = nil, args = {})
      @role_data = load_role_data(name, args)
      load_files!
      generate_site_methods!(@role_data)
    end

    ##
    # Dynamically switches the site. The 'site' argument can be either
    # a Symbol or a String.
    #
    # @role.on(:google)
    # @role.on('google')
    #
    def on(site)
      send(site)
    end

    private

    ##
    # Merge and freeze role data from YAML and custom Hash argument
    #
    def load_role_data(name, args)
      role_data = load_config("#{Huzzah.path}/roles/#{name}.yml")
      warn "No role data found for '#{name}'" if name and role_data.empty?
      merge_role_args(role_data, args).freeze
    end

    ##
    # Merge role data from the custom Hash with the data from
    # the YAML file. Any data from the custom Hash overrides data
    # from the YAML file.
    def merge_role_args(role_data, args)
      fail ArgumentError, "Expected a Hash, got #{args.first.class}" unless args.is_a?(Hash)
      role_data.merge!(args)
    end

  end
end