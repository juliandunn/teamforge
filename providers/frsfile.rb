#
# Author:: Julian Dunn (<jdunn@opscode.com>)
# Cookbook Name:: teamforge
# Provider:: frsfile
#
# Copyright:: 2013, Opscode, Inc.
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
#

use_inline_resources

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  unless @current_resource.exists

    template "/tmp/get-payload-frsid#{new_resource.frsid}.ctf" do
      cookbook "teamforge"
      source "get-payload.ctf.erb"
      owner "root"
      group "root"
      variables(
        :ctf => new_resource.ctf,
        :frsid => new_resource.frsid
      )
      action :create
      notifies :run, "execute[get-payload-from-frs]"
    end
      
    execute "get-payload-from-frs" do
      command "#{node['teamforge']['cli']['prog']} --script /tmp/get-payload-frsid#{new_resource.frsid}.ctf"
      cwd ::File.dirname(new_resource.filename)
      action :nothing
    end
  else
    Chef::Log.debug("#{@new_resource} already exists - nothing to do")
  end
end

def load_current_resource
  @current_resource = Chef::Resource::TeamforgeFrsfile.new(@new_resource.name)
  @current_resource.filename(@new_resource.filename)

  if ::File.exists?(@current_resource.filename)
    @current_resource.exists = true
  else
    @current_resource.exists = false
  end
end
