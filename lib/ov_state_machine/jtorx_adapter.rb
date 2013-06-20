require 'eventmachine'

module OVStateMachine
  class JTorXAdapter < EM::Connection
    PUBSUB = Faye::Client.new('http://localhost:9191/pubsub')
    STATUS_CODES = { checked_in: 1, checked_over: 1, checked_out: 0, failure: -1 }.freeze

    def initialize(*args)
      STATUS_CODES.each do |callback, status_code|
        PUBSUB.subscribe "/callbacks/#{callback}" do |data|
          card_id = TransitCard.instance.id
          balance = data["balance"].to_i
          send_data("reader_status!#{card_id}!#{status_code}!#{balance}\n")
        end
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
        PUBSUB.publish('/events/check_over', location_id: location_id)
      else
        PUBSUB.publish('/events/scan_card', {
          carrier_id: carrier_id,
          location_id: location_id
        })
      end
    end
  end
end
