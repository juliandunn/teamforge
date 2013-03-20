#
# Cookbook Name:: teamforge
# Recipe:: codesight
#
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

node.default['teamforge']['server']['local_features'] = %w{app etl database datamart subversion cvs codesearch}

include_recipe 'teamforge::server'

package 'teamforge-codesearch' do
  action :install
end

replace_or_add "BDCS_HOST in site-options.conf" do
  path '/opt/collabnet/teamforge-installer/6.2.0.1/conf/site-options.conf'
  pattern "BDCS_HOST=.*"
  line "BDCS_HOST=#{node['teamforge']['codesight']['public_site_name']}"
  action :edit
end

if node['teamforge']['codesight']['ssl']
  replace_or_add "BDCS_host in site-options.conf" do
    path '/opt/collabnet/teamforge-installer/6.2.0.1/conf/site-options.conf'
    pattern "BDCS_SSL=.*"
    line 'BDCS_SSL=on'
    action :edit
  end
end
