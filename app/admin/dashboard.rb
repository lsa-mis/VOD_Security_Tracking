ActiveAdmin.register_page "Dashboard" do

  def index
    authorize :dashboards, :index?
    # authorize :index?
  end

  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     # span I18n.t("active_admin.dashboard_welcome.welcome")
    #     # small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #     # span "Welcome to the Admin UI for the VOD application"
    #   end
    # end

    panel "Active Notification" do
        render("/partials/admin_dashboard_notification", model: "dashboard")
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Logins" do
          ul do
            User.recent.map do |u|
              li link_to(u.display_login_info, admin_user_path(u))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end
  end # content
end
