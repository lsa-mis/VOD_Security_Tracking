# Clear existing records in the correct order to handle foreign key constraints
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")

TdxTicket.delete_all
DpaException.delete_all
ItSecurityIncident.delete_all
LegacyOsRecord.delete_all
SensitiveDataSystem.delete_all
Device.delete_all
DataType.delete_all
DataClassificationLevel.delete_all
Department.delete_all
StorageLocation.delete_all
DpaExceptionStatus.delete_all
ItSecurityIncidentStatus.delete_all
AccessLookup.delete_all
Infotext.delete_all

ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")

AccessLookup.create!([
  {ldap_group: 'lsa-vod-admins', vod_table: 'admin_interface', vod_action: 'all'},
  {ldap_group: 'lsa-vod-devs', vod_table: 'admin_interface', vod_action: 'all'},
  {ldap_group: 'lsa-vod-devs', vod_table: 'dpa_exceptions', vod_action: 'all'},
  {ldap_group: 'lsa-vod-devs', vod_table: 'it_security_incidents', vod_action: 'all'},
  {ldap_group: 'lsa-vod-devs', vod_table: 'legacy_os_records', vod_action: 'all'},
  {ldap_group: 'lsa-vod-devs', vod_table: 'devices', vod_action: 'all'}
])

DataClassificationLevel.create!([
  {name: 'Restricted', description: 'Disclosure could cause severe harm to individuals and/or the university, including exposure to criminal and civil liability.  Has the most stringent legal or regulatory requirements and requires the most prescriptive security controls.  Legal and/or compliance regime may require assessment or certification by an external, third party.'},
  {name: 'High', description: 'Disclosure could cause significant harm to individuals and/or the university, including exposure to criminal and civil liability.  Usually subject to legal and regulatory requirements due to data that are individually identifiable, highly sensitive, and/or confidential.'},
  {name: 'Moderate', description: 'Disclosure could cause limited harm to individuals and/or the university with some risk of civil liability.  May be subject to contractual agreements or regulatory compliance, or is individually identifiable, confidential, and/or proprietary.'},
  {name: 'Low', description: 'Encompasses public information and data for which disclosure poses little to no risk to individuals and/or the university.  Anyone regardless of institutional affiliation can access without limitation.'}
])

# Create data types after data classification levels
DataType.create!([
  {name: 'ITAR', description: 'International Traffic in Arms Regulations', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/59', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'EAR', description: 'Export Administration Regulations', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/59', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'PII', description: 'Personally Identifiable Information', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/89', data_classification_level_id: DataClassificationLevel.find_by(name: 'Moderate').id},
  {name: 'PHI', description: 'Protected Health Information (PHI, regulated by HIPAA)', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/61', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'CUI', description: 'Controlled Unclassified Information', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/240', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'FISMA', description: 'Federal Information Security Management Act', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/67', data_classification_level_id: DataClassificationLevel.find_by(name: 'Restricted').id},
  {name: 'FERPA', description: 'Family Educational Rights and Privacy Act', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/62', data_classification_level_id: DataClassificationLevel.find_by(name: 'Moderate').id},
  {name: 'ACP', description: 'Attorney - Client Privileged', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/88', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'IT', description: 'IT Security Information', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/88', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'GLBA', description: 'Student Loan Application Information (regulated by GLBA)', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/63', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'SSN', description: 'Social Security Numbers', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/66', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'HSR', description: 'Sensitive Identifiable Human Subject Research', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/65', data_classification_level_id: DataClassificationLevel.find_by(name: 'High').id},
  {name: 'PCI', description: 'Credit Card or Payment Card Industry Information', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/64', data_classification_level_id: DataClassificationLevel.find_by(name: 'Restricted').id},
  {name: 'OSID', description: 'Other Sensitive Institutional Data', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/150', data_classification_level_id: DataClassificationLevel.find_by(name: 'Moderate').id}
])

Department.create!([
  {name: 'Womens Studies', shortname: 'womstds'},
  {name: 'Undergraduate Research Opportunity Program', shortname: 'urop'},
  {name: 'Technology Services', shortname: 'it'},
  {name: 'Statistics', shortname: 'stats'},
  {name: 'Sociology', shortname: 'soc'},
  {name: 'Social Science Units', shortname: 'socsci'},
  {name: 'Romance Languages and Literatures', shortname: 'rll'},
  {name: 'Residential College', shortname: 'rc'},
  {name: 'Psychology', shortname: 'psych'},
  {name: 'Political Science', shortname: 'polisci'},
  {name: 'Physics', shortname: 'phys'},
  {name: 'Anthropology', shortname: 'anth'}
])

DpaExceptionStatus.create!([
  {name: 'In Process', description: 'pending operations to complete'},
  {name: 'Approved', description: 'approval applied'},
  {name: 'Denied', description: 'declined exception'},
  {name: 'Not Pursued', description: 'will not follow up on processing'}
])

ItSecurityIncidentStatus.create!([
  {name: 'Open', description: 'currently being reviewed'},
  {name: 'On Hold', description: 'processing has been paused'},
  {name: 'Resolved', description: 'incident has been fixed'}
])

StorageLocation.create!([
  {name: 'ACS', description: 'Adobe Cloud Storage', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/247'},
  {name: 'AWSGC', description: 'Amazon Web Services GovCloud (AWSGC) at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/247'},
  {name: 'AFS', description: 'Andrew File System', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/180'},
  {name: 'ARMIS2', description: 'Armis2', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/220'},
  {name: 'BlueJeans', description: 'BlueJeans Videoconferencing', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/181'},
  {name: 'Box-NC', description: 'Box Additional Apps (Non-Core)', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/196'},
  {name: 'Box-C', description: 'Box at U-M Core Apps', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/197'},
  {name: 'Google_Drive', description: 'Google Drive at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/199'},
  {name: 'Google_Mail', description: 'Google Mail and Calendar at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/200'},
  {name: 'Google_NC', description: 'Google Non-Core Services', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/198'},
  {name: 'Gradescope', description: 'Gradescope', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/232'},
  {name: 'Great_Lakes', description: 'Great Lakes Cluster', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/246'},
  {name: 'Exch', description: 'ITS Exchange Email and Calendar', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/193'},
  {name: 'LastPass', description: 'LastPass at Michigan Medicine', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/245'},
  {name: 'Local', description: 'Local Storage Device'}
])

Infotext.create!([
  {location: 'dashboard', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'home', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'dpa_exception_index', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'dpa_exception_form', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'it_security_incident_index', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'it_security_incident_form', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'legacy_os_record_index', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'legacy_os_record_form', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'sensitive_data_system_index', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'sensitive_data_system_form', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'device_index', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
  {location: 'device_show', content: 'Click update to retrieve data about this device from the TDX database.'},
  {location: 'reports', content: 'Select a table or all tables to generate a report based on your criteria.'}
])
