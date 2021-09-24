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
      div do
        render("/partials/admin_dashboard_notification", model: "dashboard")
      end
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
        panel "Resources" do
          link_to('User Documentation', 'https://docs.google.com/document/d/1UKKiF-ymijQf2_NNhx0LzVYKkyq9YzttNO9DDKdtFwc/edit?usp=sharing', :target => "_blank")
          label: "Product", url: "#", html_options: { target: :blank }

        end
      end
    end
  end # content
end
