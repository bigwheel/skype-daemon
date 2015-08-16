require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'Skype Daemon' do

  it 'has a running service of skype-daemon' do
    expect(service('skype')).to be_running
  end

end
