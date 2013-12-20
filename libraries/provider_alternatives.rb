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
        @new_resource.bin_cmds.each do |cmd|

          unless ::File.exist?(alt_path)
            Chef::Log.info "Skipping setting alternative for #{cmd}. Command #{alt_path} does not exist."
            next
          end

          # install the alternative if needed
          install_alternative(cmd)

          # set the alternative if default
          set_alternative(cmd)
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

      private

      # Fixme: This should be a boolean.
      # Fixme: We can likely match off shell_out output instead of using grep.
      def alternative_is_set?(command)
        shell_out("update-alternatives --display #{ command }
                  | grep \"link currently points to #{alt_path}\"").exitstatus == 0
      end

      def alternative_exists?(command)
        shell_out("update-alternatives --display #{ command } | grep #{alt_path}").exitstatus == 0
      end

      def set_alternative(command)
        if @new_resource.default
          unless alternative_is_set?(command)
            description = "Set alternative for #{command}"
            converge_by(description) do
              Chef::Log.info "Setting alternative for #{command}"
              set_cmd = shell_out("update-alternatives --set #{command} #{alt_path}")
              unless set_cmd.exitstatus == 0
                Chef::Application.fatal!(%Q[ set alternative failed ])
              end
            end
            @new_resource.updated_by_last_action(true)
          end
        end
      end

      def install_alternative(command)
        unless alternative_exists?(command)
          description = "Add alternative for #{command}"
          converge_by(description) do
            Chef::Log.info "Adding alternative for #{command}"
            install_cmd = shell_out("update-alternatives --install #{bin_path} #{command} #{alt_path} #{priority}")
            unless install_cmd.exitstatus == 0
              Chef::Application.fatal!(%Q[ set alternative failed ])
            end
          end
          @new_resource.updated_by_last_action(true)
        end
      end

      def bin_path(command)
        ::File.join('/usr/bin', command)
      end

      def alt_path(command)
        "#{@new_resource.java_location}/bin/#{command}"
      end

      def bin_cmds
        @new_resource.bin_cmds
      end

      def priority
        @new_resource.priority
      end
    end
  end
end
