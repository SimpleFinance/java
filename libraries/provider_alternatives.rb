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
    # Talks to the Altneratives command and sets up symlinks.
    class JavaAlternatives < Chef::Provider
      def initialize(new_resource, run_context)
        super
        @new_resource = new_resource
        @run_context = run_context
      end

      include Chef::Mixin::ShellOut

      def load_current_resource
      end

      def action_set
        Chef::Log.info("#{bin_cmds.class}")
        Chef::Log.info("#{bin_cmds}")
        bin_cmds.each do |cmd|

          unless ::File.exist?(alt_path(cmd))
            Chef::Log.info("Command #{alt_path(cmd)} does not exist. Skipping.")
            next
          end

          # install the alternative if needed
          install_alternative(cmd)

          # set the alternative if default
          set_alternative(cmd)
        end
      end

      def action_unset
        bin_cmds.each do |cmd|
          if remove_cmd(cmd).exitstatus == 0
            @new_resource.updated_by_last_action(true)
          end
        end
      end

      private

      # FIXME: This should be a boolean.
      # FIXME: We can likely match off shell_out output instead of using grep.
      def alternative_is_set?(command)
        shell_out("update-alternatives --display #{ command }
                  | grep \"link currently points to #{alt_path(command)}\"").exitstatus == 0
      end

      def alternative_exists?(command)
        shell_out("update-alternatives --display #{ command } | grep #{alt_path(command)}").exitstatus == 0
      end

      def set_alternative(command)
        if @new_resource.default
          unless alternative_is_set?(command)
            converge_by(set_description(command)) do
              Chef::Log.info(set_description(command))
              unless set_cmd(command).exitstatus == 0
                Chef::Application.fatal!(%Q[ set alternative failed ])
              end
            end
            @new_resource.updated_by_last_action(true)
          end
        end
      end

      def install_alternative(command)
        unless alternative_exists?(command)
          converge_by(add_description(command)) do
            Chef::Log.info(add_description(command))
            unless install_cmd(command).exitstatus == 0
              Chef::Application.fatal!(%Q[ set alternative failed ])
            end
          end
          @new_resource.updated_by_last_action(true)
        end
      end

      def remove_cmd(command)
        shell_out("update-alternatives --remove #{command} #{alt_path(command)}")
      end

      def set_cmd(command)
        shell_out("update-alternatives --set #{command} #{alt_path(command)}")
      end

      def install_cmd(command)
        shell_out("update-alternatives --install \
                  #{bin_path(command)} #{command} \
                  #{alt_path(command)} #{priority}")
      end

      def set_description(command)
        "Set alternative for #{ command }"
      end

      def add_description(command)
        "Add alternative for #{ command }"
      end

      def bin_path(command)
        ::File.join('', 'usr', 'bin', command)
      end

      def alt_path(command)
        ::File.join(@new_resource.java_location, 'bin', command)
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
