class InfotextsController < ApplicationController

before_action :set_infotext, only: [:show, :edit, :update]

def index
  @infotexts = Infotext.all.with_rich_text_content
  authorize @infotexts
end

def show
  authorize @infotext
end

# def new
#   @infotext = Infotext.new
#   session[:return_to] = request.referer
#   authorize @infotext
# end

def edit
  session[:return_to] = request.referer
  authorize @infotext
end

# def create
#   @infotext = Infotext.new(infotext_params)
#   respond_to do |format|
#     if @infotext.save
#       format.turbo_stream { redirect_to session.delete(:return_to), 
#         notice: 'Text was successfully created.' 
#       }
#     else
#       format.turbo_stream
#     end
#   end
# end

def update
  respond_to do |format|
    if @infotext.update(infotext_params)
      format.turbo_stream { redirect_to session.delete(:return_to), 
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
