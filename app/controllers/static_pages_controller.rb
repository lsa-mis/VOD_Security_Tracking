class StaticPagesController < ApplicationController

  def home
    add_breadcrumb('', root_path)
  end

  def dashboard
    add_breadcrumb(action_name.titleize)
  end

end