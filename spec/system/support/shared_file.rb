shared_context "shared functions" do
    def set_session(key, value)
      Warden.on_next_request do |proxy|
        proxy.raw_session[key] = value
      end
    end

    # https://github.com/kristians-kuhta/flatpickr-testing/blob/master/spec/features/user_fills_in_date_spec.rb

    #  is not working with "Unable to find css ".flatpickr-input" that is a sibling of visible label" error
    # def fill_in_date_with_js(label_text, with:)
    #   date_field = find(:label, text: label_text).sibling('.flatpickr-input', visible: false)
    #   script = "document.querySelector('##{date_field[:id]}').flatpickr().setDate('#{with}');"
    #   page.execute_script(script)
    # end

    def fill_in_date_with_js_by_id(id, with:)
      script = "document.querySelector('##{id}').flatpickr().setDate('#{with}');"
      page.execute_script(script)
    end
end
  