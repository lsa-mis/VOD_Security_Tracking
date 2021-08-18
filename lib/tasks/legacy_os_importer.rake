# :owner_username => Point of Contact,
# :owner_full_name => LdapLookup.get_simple_name(uniqname),
# :phone => 'N/A',
# :support_poc => Region,
# :legacy_os => 'Windows 7',
# :unique_app => 'needs to be updated',
# :remediation => Required Mitigation Strategies,
# :review_date => 1.year.from_now,
# :review_contact => Exception Requester,
# :justification => Remediation Blocker Description,
# :local_it_support_group => Region,
# :notes => Additional Notes,
# :device_id => Device.new(hostname: 'Device Name'),
# :department_id => Department
desc "This will import a csv file of records into the LegacyOS table"
task legacyos_importer: :environment do
  require 'csv'
  CSV.foreach('tmp/legacyosimport.csv') do |row|
    support_poc = row[3] # Point of Contact
    department_id = row[1].to_i # Department
    device_id = Device.create(hostname: row[2]).id # Device Name
    owner_username = row[3] # Point of Contact
    justification = row[4] # Remediation Blocker Description
    remediation = row[5] # Required Mitigation Strategies
    review_contact = row[6] # Exception Requester
    notes =	row[7] # Additional Notes
    if owner_username.nil?
      owner_username = "Not avalable"
      owner_full_name = "Not avalable"
    else
      owner_full_name = LdapLookup.get_simple_name(owner_username)
      if owner_full_name.nil?
        owner_full_name = "Not avalable"
      end
    end

    phone = 'N/A'
    legacy_os = 'Windows 7'
    unique_app = 'needs to be updated'
    review_date = 1.year.from_now
    local_it_support_group = row[0]	# Region						
    record = LegacyOsRecord.new(owner_username: owner_username, owner_full_name: owner_full_name, phone: phone, support_poc: support_poc, legacy_os: legacy_os, unique_app: unique_app, remediation: remediation, review_date: review_date, review_contact: review_contact, justification: justification, local_it_support_group: local_it_support_group, notes: notes, device_id: device_id, department_id: department_id)
    if record.save
      puts "record was saved"
    else
      puts "******************ERROR"
      puts  record.errors.inspect
      puts record.errors.full_messages
      abort
    end
  end
end
