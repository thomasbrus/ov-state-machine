require 'eventmachine'

module OVStateMachine
  class JTorXAdapter < EM::Connection
    PUBSUB = Faye::Client.new('http://localhost:9191/pubsub')

    SUCCESSFUL_CHECKIN = 1
    SUCCESSFUL_CHECKOUT = 0
    UNSUCCESFUL_ACTION = -1

    def initialize(*args)
      PUBSUB.subscribe '/callbacks/check_in' do |event_data|
        balance = event_data["balance"].to_i
        send_data("reader_status!100!#{SUCCESSFUL_CHECKIN}!#{balance}\n")
      end

      PUBSUB.subscribe '/callbacks/check_out' do |event_data|
        balance = event_data["balance"].to_i
        send_data("reader_status!100!#{SUCCESSFUL_CHECKOUT}!#{balance}\n")
      end

      PUBSUB.subscribe '/callbacks/failure' do |event_data|
        balance = event_data["balance"].to_i
        send_data("reader_status!100!#{UNSUCCESFUL_ACTION}!#{balance}\n")
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
