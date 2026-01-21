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

    # Dashboard columns using div elements for Active Admin 4.0 compatibility
    div class: "grid grid-cols-1 lg:grid-cols-2 gap-4 mt-4" do
      div do
        panel "Recent Logins" do
          ul do
            User.recent.map do |u|
              li link_to(u.display_login_info, admin_user_path(u))
            end
          end
        end
      end

      div do
        panel "Resources" do
          ul do
            li link_to('User Documentation', 'https://docs.google.com/document/d/1UKKiF-ymijQf2_NNhx0LzVYKkyq9YzttNO9DDKdtFwc/edit?usp=sharing', :target => "_blank")
            li link_to('Admin Documentation', 'https://docs.google.com/document/d/1xpk79I9FVJ1JPn89oFEedoVtljj6IGwB1K3ub8mEyMI/edit?usp=sharing', :target => "_blank")
          end
        end
      end
    end
  end # content
end
