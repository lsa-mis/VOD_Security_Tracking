# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# AdminUser.create!(email: 'admin@example.com', password: 'secretsecret', password_confirmation: 'secretsecret', username: "admin") if Rails.env.development?

StorageLocation.create!([
  {name: 'ACS', description: 'Adobe Cloud Storage', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/247'},
  {name: 'AWSGC', description: 'Amazon Web Services GovCloud (AWSGC) at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/247'},
  {name: 'AFS', description: 'Andrew File System', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/180'},
  {name: 'ARMIS2', description: 'Armis2', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/220'},
  {name: 'BlueJeans', description: 'BlueJeans Videoconferencing', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/181'},
  {name: 'Box-NC', description: 'Box Additional Apps (Non-Core)', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/196'},
  {name: 'Box-C', description: 'Box at U-M Core Apps', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/197'},
  {name: 'Canvas', description: 'Canvas', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/182'},
  {name: 'CSIwS', description: 'Cloud Storage Included with Software', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/183'},
  {name: 'DW', description: 'Data Warehouse', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/185'},
  {name: 'Code42', description: 'Desktop Backup (Powered by Code42)', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/186'},
  {name: 'DS', description: 'Digital Signage', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/188'},
  {name: 'DIS', description: 'Documnet Imaging System', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/221'},
  {name: 'DB', description: 'Dropbox at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/251'},
  {name: 'SignNow', description: 'E-Signature Service - SignNow', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/228'},
  {name: 'Echo360', description: 'Echo360 - Lecture Capture and Lecture Tools', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/189'},
  {name: 'ERN', description: 'Electronic Research Notebook at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/235'},
  {name: 'eResearch', description: 'eResearch Storage', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/190'},
  {name: 'Globus', description: 'Globus Storage', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/192'},
  {name: 'Google_Core', description: 'Google at U-M Core Services', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/201'},
  {name: 'Google_Cloud', description: 'Google Cloud Platform at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/237'},
  {name: 'Google_Drive', description: 'Google Drive at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/199'},
  {name: 'Google_Mail', description: 'Google Mail and Calendar at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/200'},
  {name: 'Google_NC', description: 'Google Non-Core Services', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/198'},
  {name: 'Gradescope', description: 'Gradescope', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/232'},
  {name: 'Great_Lakes', description: 'Great Lakes Cluster', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/246'},
  {name: 'Exch', description: 'ITS Exchange Email and Calendar', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/193'},
  {name: 'LastPass', description: 'LastPass at Michigan Medicine', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/245'},
  {name: 'Local', description: 'Local Storage Device'},
  {name: 'MiBackup', description: 'MiBackup', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/215'},
  {name: 'Mi-Med', description: 'Michigan Medicine Exchange/Outlook Email and Calendar', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/218'},
  {name: 'Azure', description: 'Microsoft Azure at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/236'},
  {name: 'MS365', description: 'Microsoft Office 365 at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/244'},
  {name: 'MS-Teams', description: 'Microsoft Teams at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/254'},
  {name: 'MiDatabase', description: 'MiDatabase', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/202'},
  {name: 'MiDesktop', description: 'MiDesktop', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/187'},
  {name: 'MiServer', description: 'MiServer', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/203'},
  {name: 'MiShare', description: 'MiShare', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/204'},
  {name: 'MiStorage_NFS', description: 'MiStorage (NFS)', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/206'},
  {name: 'MiStorage_CIFS', description: 'MiStorage CIFS with AWS S3 Cloud Storage Integration', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/205'},
  {name: 'MiVideo', description: 'MiVideo', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/207'},
  {name: 'MiWorkspace', description: 'MiWorkspace', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/208'},
  {name: 'Other', description: 'Storage location used not on this list'},
  {name: 'Personal_Acc', description: 'Personal Accounts', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/209'},
  {name: 'POD', description: 'Personally Owned Devices (Phone, Tablet, Laptop, etc..)', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/210'},
  {name: 'Perusall', description: 'Perusall', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/238'},
  {name: 'Piazza', description: 'Piazza Q & A', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/230'},
  {name: 'Qualtrics', description: 'Qualtrics', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/211'},
  {name: 'ServiceNow', description: 'ServiceNow at Michigan Medicine', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/212'},
  {name: 'TDX', description: 'TeamDynamix at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/250'},
  {name: 'Turbo_NFS', description: 'Turbo Research Storage (NFS)', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/216'},
  {name: 'Virtru', description: 'Virtru at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/252'},
  {name: 'Yottabyte', description: 'Yottabyte Research Cloud', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/239'},
  {name: 'Zoom', description: 'Zoom at U-M', description_link: 'https://safecomputing.umich.edu/dataguide/?q=node/248'}
  ])

DataClassificationLevel.create!([
  {name: 'Restricted', description: 'Disclosure could cause severe harm to individuals and/or the university, including exposure to criminal and civil liability.  Has the most stringent legal or regulatory requirements and requires the most prescriptive security controls.  Legal and/or compliance regime may require assessment or certification by an external, third party.'},
  {name: 'High', description: 'Disclosure could cause significant harm to individuals and/or the university, including exposure to criminal and civil liability.  Usually subject to legal and regulatory requirements due to data that are individually identifiable, highly sensitive, and/or confidential.'},
  {name: 'Moderate', description: 'Disclosure could cause limited harm to individuals and/or the university with some risk of civil liability.  May be subject to contractual agreements or regulatory compliance, or is individually identifiable, confidential, and/or proprietary.'},
  {name: 'Low', description: 'Encompasses public information and data for which disclosure poses little to no risk to individuals and/or the university.  Anyone regardless of institutional affiliation can access without limitation.'}
  ])

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

DpaExceptionStatus.create!([ 
  {name: 'In Process', description: 'pending operations to complete'},
  {name: 'Approved', description: 'approval applied'},
  {name: 'Denied', description: 'declined exception'},
  {name: 'Not Pursued', description: 'will not follow up on processing'}
  ])

  AccessLookup.create!([
    {ldap_group: 'lsa-vod-admins', table: 'admin_interface', action: 'all_actions'},
    {ldap_group: 'lsa-vod-devs', table: 'admin_interface', action: 'all_actions'}
  ])