class ApplicationSettingsController < ApplicationController

  before_action :set_application_setting, only: [:show, :edit, :update, :destroy]

  def index
    @application_settings = ApplicationSetting.all.with_rich_text_content
  end

  def show
  end

  def new
    @application_setting = ApplicationSetting.new
    session[:return_to] = request.referer
  end

  def edit
    session[:return_to] = request.referer
  end

  def create
    @application_setting = ApplicationSetting.new(application_setting_params)
    respond_to do |format|
      if @application_setting.save
        format.turbo_stream { redirect_to session.delete(:return_to), 
          notice: 'Text was successfully created.' 
        }
      else
        format.turbo_stream
      end
    end
  end

  def update
    respond_to do |format|
      if @application_setting.update(application_setting_params)
        format.turbo_stream { redirect_to session.delete(:return_to), 
        notice: 'Text was successfully updated.' 
      }
    else
      format.turbo_stream
      end
    end
  end

  def destroy
    @application_setting.destroy
    respond_to do |format|
      format.html { redirect_to application_settings_url, notice: 'application_setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    def set_application_setting
      @application_setting = ApplicationSetting.find(params[:id])
    end

  private

    def set_application_setting
      @application_setting = ApplicationSetting.find(params[:id])
    end

    def application_setting_params
      params.require(:application_setting).permit(:title, :content)
    end

end
