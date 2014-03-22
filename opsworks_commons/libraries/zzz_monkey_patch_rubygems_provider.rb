#
# Support opsworks user-space ruby stacks
require 'chef/provider/package'

class Chef
  class Provider
    class Package
      class Rubygems < Chef::Provider::Package
        class GemEnvironment
          ##
          # Lists the installed versions of +gem_dep.name+, constrained by the
          # version spec in +gem_dep.requirement+
          # Uses OpsWorksUserSpaceGems.installed_versions to find gem in the
          # OpsWorks user space ruby environment if @gem_binary_location id defined
          #
          # === Arguments
          # Gem::Dependency   +gem_dep+ is a Gem::Dependency object, its version
          #                   specification constrains which gems are returned.
          # === Returns
          # [Gem::Specification]  an array of Gem::Specification objects
          def installed_versions(gem_dep)
            # @gem_binary_location is defined in Chef::Resource::GemPackage
            if @gem_binary_location.present? && (::File.exists?(@gem_binary_location) || working_gem_commandline?(@gem_binary_location))
                OpsWorksUserSpaceGems.new(@gem_binary_location).installed_versions(
                  gem_dep.name,
                  gem_dep.requirement
                )
            elsif Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.8.0')
                gem_specification.find_all_by_name(gem_dep.name, gem_dep.requirement)
              else
                gem_source_index.search(gem_dep)
            end
          end

          private

          def working_gem_commandline?(command_line)
            # rbenv substitutes the call to the plain gem binary with a
            # complexer commandline consisting of ENV var settings etc.
            # So, try to execute the commandline with an added help flag to
            # mitigate possible damages.
            # This can be DANGEROUS!
            system("#{cmd} --help > /dev/null 2>&1")
          end
        end

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
