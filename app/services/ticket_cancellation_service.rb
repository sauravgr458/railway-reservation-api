# frozen_string_literal: true

class TicketCancellationService
  def initialize(ticket_id)
    @ticket = Ticket.find_by_id(ticket_id)
  end

  def call
    return [false, 'Ticket not found'] unless @ticket

    Ticket.transaction do
      @ticket.destroy!

      rac_ticket = Ticket.rac.order(:created_at).first
      if rac_ticket
        rac_ticket.update!(status: 'confirmed', berth_type: 'lower')
        promote_waiting_to_rac
      end
      [true, 'Ticket cancelled successfully']
    end
  end

  private

  def promote_waiting_to_rac
    waiting = Ticket.waiting_list.order(:created_at).first
    waiting&.update!(status: 'rac', berth_type: 'side-lower')
  end
end
