#
# Support opsworks user-space ruby stacks
require 'chef/provider/package'

class Chef
  class Provider
    class Package
      class Rubygems < Chef::Provider::Package
        #
        # manage opsworks user space gems
        class OpsWorksUserSpaceGems
          ##
          # Lists the installed versions of +gem_dep.name+, constrained by the
          # version spec in +gem_dep.requirement+
          # === Arguments
          # name          the name of the gem to look for
          # requirement   the requirement for this gem
          # === Returns
          # [Gem::Specification]  an array of Gem::Specification objects
          def installed_versions(name, requirement)
            if gem_installed?(name, requirement)
              Chef::Log.info "Patch: Gem #{name} (#{requirement}) found in OpsWorks user space."
              [Gem::Specification.new(name)]
            else
              Chef::Log.debug "Patch: Gem #{name} (#{requirement}) not found in OpsWorks user space."
              []
            end
          end

        end

      end
    end
  end
end
