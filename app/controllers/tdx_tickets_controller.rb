class TdxTicketsController < ApplicationController

  def create
      @tdx_ticket = @record_to_tdx.tdx_tickets.new tdx_ticket_params

    respond_to do |format|
      if @tdx_ticket.save 
        format.turbo_stream { redirect_to @record_to_tdx, 
                              notice: "Your ticket was added" 
                            }
      else
        format.turbo_stream { redirect_to @record_to_tdx, 
          alert: "Fail: you need to enter a ticket link" 
        }
      end
    end
  end

  def destroy
    @tdx_ticket = TdxTicket.find(params[:id])
    @tdx_ticket.destroy
    redirect_back(fallback_location: request.referer, 
                  notice: "Your ticket was deleted")
  end

  private

    def tdx_ticket_params
        params.require(:tdx_ticket).permit(:ticket_link)
    end
end