
# check httpd package is installed
describe package 'openssh' do
  it { should be_installed }
end

# check httpd service is running and enabled
describe service 'openssh' do
  it { should be_enabled }
  it { should be_running }
end