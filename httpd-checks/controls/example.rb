# copyright: 2018, The Authors

title "HTTP Checks"

# check httpd package is installed
control 'httpd-01' do
  impact 1.0
  title 'httpd Package'
  desc 'The httpd package should be installed'
  describe package 'httpd' do
    it { should be_installed }
  end
end

# check httpd service is running and enabled
control 'httpd-02' do
  impact 1.0
  title 'httpd Service'
  desc 'The httpd service should be enabled and running'
  describe service 'httpd' do
    it { should be_enabled }
    it { should be_running }
  end
end

# check httpd is listening on port 80
control 'httpd-03' do
  impact 1.0
  title 'Port 80 Listening'
  desc 'The httpd service should be listening on port 80'
  describe port 80 do
    it { should be_listening }
  end
end
