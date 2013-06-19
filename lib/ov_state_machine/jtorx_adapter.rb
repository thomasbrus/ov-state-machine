require 'eventmachine'

module OVStateMachine
  class JTorXAdapter < EM::Connection
    PUBSUB = Faye::Client.new('http://localhost:9191/pubsub')

    def receive_data(line)
      action, *args = decode(line)

      if action == "show"
        handle_show(*args)
      else
        send_data("Unknown action: #{action}\n")
      end
    end

    private

    def decode(line)
      line.strip.split('!').map(&:strip)
    end

    def handle_show(card_id, carrier_id, location_id)
      if carrier_id == 0
        PUBSUB.publish('/events/check_over', {
          location_id: location_id
        })
      else
        PUBSUB.publish('/events/scan_card', {
          carrier_id: carrier_id,
          location_id: location_id
        })
      end
    end
  end
end
