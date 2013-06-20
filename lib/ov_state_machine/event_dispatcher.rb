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

    def publish_check_in(card, location, carrier)
      @pubsub.publish("/callbacks/checked_in", {
        location_id: location.id,
        balance: card.balance,
        location_name: location.name,
        carrier_name: carrier.name
      })
    end

    def publish_check_over(card, location)
      @pubsub.publish("/callbacks/checked_over", {
        location_id: location.id,
        balance: card.balance,
        location_name: location.name,
        carrier_name: Carrier.get(0).name,
        is_checked_in: card.checked_in?
      })
    end

    def publish_check_out(card, location)
      @pubsub.publish("/callbacks/checked_out", {
        location_id: location.id,
        balance: card.balance
      })
    end

    def publish_failure(card, location)
      @pubsub.publish("/callbacks/failure", {
        location_id: (location.id rescue nil),
        balance: (card.balance rescue nil)
      })
    end

    private

    def on_scan_card(event_data)
      card = TransitCard.instance
      location = Location.get!(event_data['location_id'])
      carrier = Carrier.get!(event_data['carrier_id'])
      handle_scan_card(card, location, carrier)
    rescue DataMapper::ObjectNotFoundError
      publish_failure(card, location)
    end

    def on_check_over(event_data)
      card = TransitCard.instance
      location = Location.get!(event_data['location_id'])
      handle_check_over(card, location)
    rescue DataMapper::ObjectNotFoundError
      publish_failure(card, location)
    end

    def handle_scan_card(card, location, carrier)
      if card.checked_in?
        card.check_out(location, carrier)
        publish_check_out(card, location)
        puts "Checked out at #{location.name}, using #{carrier.name}"
      else
        card.check_in(location, carrier)
        publish_check_in(card, location, carrier)
        puts "Checked in at #{location.name}, using #{carrier.name}"
      end
    rescue TransitCard::InvalidAction => e
      puts e.message
      publish_failure(card, location)
    end

    def handle_check_over(card, location)
      card.check_over(location)
      publish_check_over(card, location)
      puts "Checked over at #{location.name}"
    rescue TransitCard::InvalidAction => e
      puts e.message
      publish_failure(card, location)
    end
  end
end
