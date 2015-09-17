module Huzzah
  module Locator

    def locator(method_name, &block)
      validate_method_name method_name

      define_method method_name.to_s do |*args|
        instance_exec(*args, &block)
      end
    end

    def validate_method_name(name, restrict = true)
      if defined_methods.include? name
        fail Huzzah::DuplicateLocatorMethodError, name
      elsif restrict && Watir::Container.instance_methods.include?(name)
        fail Huzzah::RestrictedMethodNameError,
             %(You cannot use method names like '#{name}' from
                 the Watir::Container module in 'locator' statements)
      else
        defined_methods << name
      end
    end

    def defined_methods
      @defined_methods ||= []
    end

  end
end