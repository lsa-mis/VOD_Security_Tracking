LdapLookup.configuration do |config|
  config.host = "ldap.umich.edu" # "ldap.umich.edu"
  config.port = 389 # "954" port 389 is set by default
  config.base = "dc=umich,dc=edu" # "dc=umich,dc=edu"
  config.dept_attribute = "umichPostalAddressData" # "umichPostalAddressData"
  config.group_attribute = "umichGroupEmail" # "umichGroupEmail"
end