#
# Cookbook Name:: skype-daemon
# Recipe:: default
#

include_recipe 'apt'
include_recipe 'xmledit'

#####################
# Installation part #
#####################
apt_repository 'partner' do
  uri 'http://archive.canonical.com'
  components %w(partner)
  distribution node['lsb']['codename']
  action :add
end

%w[skype fonts-takao xvfb x11vnc].each do |package_name|
  package package_name do
    action :install
  end
end

##################
# Deamonize part #
##################
group 'skype' do
  group_name 'skype'
  action [:create]
end

user 'skype' do
  group 'skype'
  password nil
  action [:create]
  home '/home/skype'
  manage_home true
end

template '/usr/lib/systemd/scripts/skype.sh' do
  source 'skype.sh.erb'
  mode '0755'
end

template '/lib/systemd/system/skype.service' do
  source 'skype.service'
end

service('skype.service') { action :stop }
execute('sleep 3')

# create skype global config
unless FileTest::exist?('/home/skype/.Skype')
  service('skype.service') { action :start }
  execute('sleep 30')
  service('skype.service') { action :stop }
  execute('sleep 3')
end

xml_edit 'add EURA agreements' do
  path '/home/skype/.Skype/shared.xml'
  action :append_if_missing
  target '/config/UI'
  parent '/config'
  fragment '<UI><Installed>2</Installed></UI>'
end

# create skype user config
unless FileTest::exist?("/home/skype/.Skype/#{node['skype-daemon']['username']}/config.xml")
  service('skype.service') { action :start }
  execute('sleep 30')
  service('skype.service') { action :stop }
  execute('sleep 3')
end

xml_edit 'add 3rd party API authorization(base)' do
  path "/home/skype/.Skype/#{node['skype-daemon']['username']}/config.xml"
  action :append_if_missing
  target '/config/UI'
  parent '/config'
  fragment <<-FRAG
  <UI>
  </UI>
  FRAG
end

xml_edit 'add 3rd party API authorization' do
  path "/home/skype/.Skype/#{node['skype-daemon']['username']}/config.xml"
  action :append_if_missing
  target '/config/UI/API'
  parent '/config/UI'
  fragment <<-FRAG
    <API>
      <Authorizations>#{node['skype-daemon']['app-name']}</Authorizations>
      <BlockedPrograms></BlockedPrograms>
    </API>
  FRAG
end

service 'skype.service' do
  action [ :enable, :start ]
end
