# 2020, cloud.gov

title "SC-20 controls"

# you add controls here
control "SC-20(b)" do
  impact 0.7
  title "HSTS headers are set appropriately"

  require 'net/http'
  http = Net::HTTP.new("cloud.gov", 443)
  http.use_ssl = true
  response = http.head("/")

  describe response['strict-transport-security'] do
    it { should cmp "max-age=31536000; includeSubDomains; preload" }
  end
end
