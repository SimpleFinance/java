#
# Cookbook Name:: java
# Resource:: alternatives
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

require 'chef/resource'
require_relative 'provider_alternatives'

class Chef
  class Resource
    # Sets up symlinks Java
    class JavaAlternatives < Chef::Resource
      state_attrs :priority, :java_location, :bin_cmds

      # we have to set default for the supports attribute
      # in initializer since it is a 'reserved' attribute name
      def initialize(name, run_context = nil)
        super
        @resource_name = :java_alternatives
        @action = :set
        @allowed_actions = [:set, :unset]
        @provider = Chef::Provider::JavaAlternatives
      end

      def java_location(arg = nil)
        set_or_return(:java_location,
                      arg,
                      kind_of: String,
                      default: nil)
      end

      def bin_cmds(arg = nil)
        set_or_return(:bin_cmds,
                      arg,
                      kind_of: Array,
                      default: all_java_binaries)
      end

      def default(arg = nil)
        set_or_return(:default,
                      arg,
                      kind_of: [TrueClass, FalseClass],
                      default: true)
      end

      def priority(arg = nil)
        set_or_return(:priority,
                      arg,
                      kind_of: Fixnum,
                      default: 1061)
      end

      def all_java_binaries
        %w(appletviewer apt ControlPanel extcheck
           idlj jar jarsigner java javac javadoc javafxpackager javah
           javap javaws jcmd jconsole jcontrol jdb jhat jinfo jmap jps
           jrunscript jsadebugd jstack jstat jstatd jvisualvm keytool
           native2ascii orbd pack200 policytool rmic rmid rmiregistry
           schemagen serialver servertool tnameserv unpack200 wsgen
           wsimport xjc)
      end
    end
  end
end
