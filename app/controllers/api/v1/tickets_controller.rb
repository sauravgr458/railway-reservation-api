# frozen_string_literal: true

class Api::V1::TicketsController < ApplicationController
  def book
    service = TicketBookingService.new(ticket_params[:passengers])
    ticket = service.call
    render json: { message: 'Ticket booked successfully', ticket: ticket }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def cancel
    success, message = TicketCancellationService.new(params[:id]).call
    render json: { message: message }, status: success ? :ok : :unprocessable_entity
  end

  def booked
    @tickets = Ticket.includes(:passengers).where(status: 'confirmed')
    render json: @tickets.as_json(include: :passengers), status: :ok
  end

  def available
    render json: {
      confirmed: 63 - Ticket.confirmed.count,
      rac: 18 - Ticket.rac.count,
      waiting_list: 10 - Ticket.waiting_list.count
    }
  end

  private

  def ticket_params
    params.require(:ticket).permit(passengers: %i[name age gender has_child])
  end
end
