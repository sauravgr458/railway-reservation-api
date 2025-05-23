# frozen_string_literal: true

class TicketBookingService
  BERTH_LIMIT = 63
  RAC_LIMIT = 18
  WL_LIMIT  = 10

  def initialize(passenger_params)
    @passenger_params = passenger_params
  end

  def call
    Ticket.transaction do
      berth_count = Ticket.confirmed.count
      rac_count   = Ticket.rac.count
      wl_count    = Ticket.waiting_list.count

      status, berth_type = allocate_status_and_berth(berth_count, rac_count, wl_count)

      raise StandardError, 'No tickets available' if status.nil?

      ticket = Ticket.create!(status: status, berth_type: berth_type)
      @passenger_params.each do |params|
        Passenger.create!(params.merge(ticket: ticket))
      end

      ticket
    end
  end

  private

  def allocate_status_and_berth(confirmed, rac, wl_count)
    return ['confirmed', preferred_berth_type] if confirmed < BERTH_LIMIT
    return %w[rac side-lower] if rac < RAC_LIMIT
    return ['waiting_list', nil] if wl_count < WL_LIMIT

    [nil, nil]
  end

  def preferred_berth_type
    primary = @passenger_params.first
    if primary['age'].to_i >= 60 || (primary['gender'] == 'female' && primary['has_child'])
      'lower'
    else
      %w[middle upper lower].sample
    end
  end
end
