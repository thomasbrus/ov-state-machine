require 'eventmachine'

module OVStateMachine
  class EventDispatcher
    def initialize(pubsub)
      @pubsub = pubsub

      @pubsub.subscribe '/events/scan_card' do |event_data|
        on_scan_card(event_data)
      end

      @pubsub.subscribe '/events/check_over' do |event_data|
        on_check_over(event_data)
      end
    end

    def publish_check_in(location, carrier)
      @pubsub.publish("/callbacks/check_in/#{location.id}", {
        location_name: location.name,
        carrier_name: carrier.name
      })
    end

    def publish_check_out(location, balance)
      @pubsub.publish("/callbacks/check_out/#{location.id}", {
        balance: balance
      })
    end

    def publish_failure(location, balance)
      @pubsub.publish("/callbacks/failure/#{location.id}", {
        balance: balance
      })
    end

    private

    def on_scan_card(event_data)
      card = TransitCard.instance
      location = Location.get!(event_data['location_id'])
      carrier = Carrier.get!(event_data['carrier_id'])
      handle_scan_card(card, location, carrier)
    rescue DataMapper::ObjectNotFoundError => e
      puts e.message
      publish_failure(location, card.balance)
    end

    def on_check_over(event_data)
      card = TransitCard.instance
      location = Location.get!(event_data['location_id'])
      handle_check_over(card, location)
    rescue DataMapper::ObjectNotFoundError => e
      puts e.message
      publish_failure(location, card.balance)
    end

    def handle_scan_card(card, location, carrier)
      if card.checked_in?
        card.check_out(location, carrier)
        publish_check_out(location, card.balance)
      else
        card.check_in(location, carrier)
        publish_check_in(location, carrier)
      end
    rescue TransitCard::InvalidAction => e
      puts e.message
      publish_failure(location, card.balance)
    end

    def handle_check_over(card, location)
      card.check_over(location)
      publish_check_in(location, Carrier.get(0))
    rescue TransitCard::InvalidAction => e
      puts e.message
      publish_failure(location, card.balance)
    end
  end
end
