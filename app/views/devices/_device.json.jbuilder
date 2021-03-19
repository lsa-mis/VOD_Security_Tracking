json.extract! device, :id, :serial, :hostname, :mac, :building, :room, :created_at, :updated_at
json.url device_url(device, format: :json)
