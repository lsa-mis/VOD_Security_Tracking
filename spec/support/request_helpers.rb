module RequestHelpers
  def set_session(key, value)
    Warden.on_next_request do |proxy|
      proxy.raw_session[key] = value
    end
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
