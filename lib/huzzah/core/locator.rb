module Huzzah
  module Locator
    ##
    # DSL method for creating aliases of watir locator statements
    # within your page-objects. It will not allow duplicate aliases within
    # the same page-object and will not allow a name that conflicts with
    # a Watir::Container method name.
    #
    # Example:
    # module Google
    #   class HomePage < Huzzah::Page
    #
    #     locator(:search_box) { text_field(name: 'q') }
    #
    #   end
    # end
    #
    # Example Call:
    #   @user.google.home_page.search_box.set('Huzzah')
    #
    def locator(name, &block)
      validate_alias(name)
      define_method(name) { |*args| instance_exec(*args, &block) }
    end

    private

    ##
    # Ensures that validate locator aliases are used.
    # Arguments:
    #   name - the alias
    #   restrict - prevents using alias names that collide with method
    #              names in the Watir::Container module. Optional.
    #              Defaulted to true
    #
    def validate_alias(name, restrict = true)
      if defined_aliases.include?(name)
        fail Huzzah::DuplicateLocatorMethodError, name
      end
      if restrict && Watir::Container.instance_methods.include?(name)
        fail Huzzah::RestrictedMethodNameError,
             %q(You cannot use method names like '#{name}' from the
                  Watir::Container module in 'locator' statements)
      else
        defined_aliases << name
      end
    end

    ##
    # Array of defined locator aliases.
    #
    def defined_aliases
      @defined_aliases ||= []
    end
  end
end
