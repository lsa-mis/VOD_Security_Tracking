module AdminHelper
  def admin_nav_link(label, path, active: false)
    classes = "block px-3 py-2 rounded text-sm #{active ? 'bg-sky-700 text-white' : 'text-sky-100 hover:bg-sky-800'}"
    link_to label, path, class: classes
  end

  def admin_scope_tabs(scopes, current_scope)
    content_tag :div, class: "flex gap-2 mb-4 flex-wrap" do
      safe_join(
        scopes.map do |scope_name|
          active = current_scope.to_s == scope_name.to_s
          link_to scope_name.to_s.humanize,
                  url_for(scope: scope_name),
                  class: "px-3 py-1 rounded text-sm border #{active ? 'bg-sky-700 text-white border-sky-700' : 'bg-white text-gray-700 border-gray-300'}"
        end
      )
    end
  end

  def admin_attr_rows(record, attributes)
    content_tag :dl, class: "grid grid-cols-1 md:grid-cols-2 gap-4" do
      safe_join(
        attributes.map do |attr|
          label, value =
            if attr.is_a?(Array)
              [attr[0], attr[1]]
            else
              [attr.to_s.humanize, record.public_send(attr)]
            end
          content_tag(:div) do
            content_tag(:dt, label, class: "text-xs uppercase tracking-wide text-gray-500") +
              content_tag(:dd, value.presence || "—", class: "text-sm text-gray-900 mt-1")
          end
        end
      )
    end
  end

  def admin_current_section?(prefixes)
    Array(prefixes).any? { |prefix| request.path.start_with?(prefix) }
  end
end
