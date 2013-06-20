require 'eventmachine'

module OVStateMachine
  class JTorXAdapter < EM::Connection
    STATUS_CODES = { checked_in: 1, checked_out: 0, failure: -1 }.freeze

    def initialize(pubsub)
      @pubsub = pubsub

      STATUS_CODES.each do |callback, status_code|
        @pubsub.subscribe "/callbacks/#{callback}" do |data|
          balance = data["balance"].to_i
          report_reader_status(status_code, balance)
        end
      end

      @pubsub.subscribe "/callbacks/checked_over" do |data|
        balance = data["balance"].to_i
        status_code = determine_checked_over_status_code(data)
        report_reader_status(status_code, balance)
      end

      super
    end

    def receive_data(line)
      action, *args = decode(line)

      if action == "show"
        handle_show(*args)
      elsif action.nil?
        send_data("Empty line received.\n")
      else
        send_data("Unknown action received: #{action}.\n")
      end
    end

    private

    def decode(line)
      line.strip.split('!').map(&:strip)
    end

    def handle_show(card_id, carrier_id, location_id)
      if carrier_id.to_i == 0
        @pubsub.publish('/events/check_over', location_id: location_id)
      else
        @pubsub.publish('/events/scan_card', {
          carrier_id: carrier_id,
          location_id: location_id
        })
      end
    end

    def report_reader_status(status_code, balance)
      # For now there's only one card
      card_id = TransitCard.instance.id
      send_data("reader_status!#{card_id}!#{status_code}!#{balance}\n")
    end

    def determine_checked_over_status_code(data)
      STATUS_CODES.fetch(data["is_checked_in"] ? :checked_in : :checked_out)
    end
  end
end
