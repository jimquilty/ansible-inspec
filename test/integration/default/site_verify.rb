
# check httpd package is installed
describe package 'httpd' do
  it { should be_installed }
end

# # check httpd service is running and enabled
# describe service 'httpd' do
#   it { should be_enabled }
#   it { should be_running }
# end

# # check httpd is listening on port 80
# describe port 80 do
#   it { should be_listening }
# end