#
# Cookbook Name:: java
# Provider:: alternatives
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef/provider'
require 'chef/mixin/shell_out'

class Chef
  class Provider
    class JavaAlternatives < Chef::Provider

      def initialize(*args)
        super
      end

      include Chef::Mixin::ShellOut

      def action_set
        if @new_resource.bin_cmds
          @new_resource.bin_cmds.each do |cmd|

            bin_path = "/usr/bin/#{cmd}"
            alt_path = "#{@new_resource.java_location}/bin/#{cmd}"
            priority = @new_resource.priority

            unless ::File.exist?(alt_path)
              Chef::Log.info "Skipping setting alternative for #{cmd}. Command #{alt_path} does not exist."
              next
            end

            # install the alternative if needed
            alternative_exists = shell_out("update-alternatives --display #{cmd} | grep #{alt_path}").exitstatus == 0
            unless alternative_exists
              description = "Add alternative for #{cmd}"
              converge_by(description) do
                Chef::Log.info "Adding alternative for #{cmd}"
                install_cmd = shell_out("update-alternatives --install #{bin_path} #{cmd} #{alt_path} #{priority}")
                unless install_cmd.exitstatus == 0
                  Chef::Application.fatal!(%Q[ set alternative failed ])
                end
              end
              @new_resource.updated_by_last_action(true)
            end

            # set the alternative if default
            if @new_resource.default
              alternative_is_set = shell_out("update-alternatives --display #{cmd} | grep \"link currently points to #{alt_path}\"").exitstatus == 0
              unless alternative_is_set
                description = "Set alternative for #{cmd}"
                converge_by(description) do
                  Chef::Log.info "Setting alternative for #{cmd}"
                  set_cmd = shell_out("update-alternatives --set #{cmd} #{alt_path}")
                  unless set_cmd.exitstatus == 0
                    Chef::Application.fatal!(%Q[ set alternative failed ])
                  end
                end
                @new_resource.updated_by_last_action(true)
              end
            end
          end
        end
      end

      def action_unset
        @new_resource.bin_cmds.each do |cmd|
          alt_path = "#{@new_resource.java_location}/bin/#{cmd}"
          cmd = shell_out("update-alternatives --remove #{cmd} #{alt_path}")
          if cmd.exitstatus == 0
            @new_resource.updated_by_last_action(true)
          end
        end
      end
    end
  end
end
