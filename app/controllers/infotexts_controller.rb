class InfotextsController < ApplicationController

  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user]
  before_action :authenticate_logged_in!
  before_action :set_infotext, only: [:show, :edit, :update]

  def index
    @infotexts = Infotext.all.with_rich_text_content
    authorize @infotexts
  end

  def show
    authorize @infotext
  end

  def edit
    session[:return_to] = request.referer
    authorize @infotext
  end

  def update
    respond_to do |format|
      if @infotext.update(infotext_params)
        format.turbo_stream { redirect_to @infotext, 
        notice: 'Text was successfully updated.' 
      }
    else
      format.turbo_stream
      end
    end
  end

  private

    def set_infotext
      @infotext = Infotext.find(params[:id])
    end

    def infotext_params
      params.require(:infotext).permit(:location, :content)
    end

end
