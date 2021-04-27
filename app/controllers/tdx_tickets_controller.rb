class TdxTicketsController < ApplicationController

  def create
      @tdx_ticket = @record_to_tdx.tdx_tickets.new tdx_ticket_params
      @tdx_ticket.save
      redirect_to @record_to_tdx, notice: "Your ticket was added"
  end

  def destroy
    @tdx_ticket = @record_to_tdx.tdx_tickets.find(params[:id])
    @tdx_ticket.destroy
    redirect_to @record_to_tdx, notice: "Your ticket was deleted"
  end

  private

    def tdx_ticket_params
        params.require(:tdx_ticket).permit(:ticket_link)
    end
  end