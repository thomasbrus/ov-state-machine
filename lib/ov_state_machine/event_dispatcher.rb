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

    def publish_success(event, location, card)
      @pubsub.publish("/callbacks/#{event}/#{location.id}", {
        balance: card.balance
      })
    end

    def publish_failure(location, card)
      @pubsub.publish("/callbacks/failure/#{location.id}", {
        balance: card.balance
      })
    end

    private

    def on_scan_card(event_data)
      card = TransitCard.new(event_data['card_id'])
      location = Location.new(event_data['location_id'])
      carrier = Carrier.new(event_data['carrier_id'])
      handle_scan_card(card, location, carrier)
    end

    def on_check_over(event_data)
      card = TransitCard.new(event_data['card_id'])
      location = Location.new(event_data['location_id'])
      handle_check_over(card, location)
    end

    def handle_scan_card(card, location, carrier)
      if card.checked_in?
        card.check_out(carrier, location)
        publish_success(:check_out, location, card)        
      else
        card.check_in(carrier, location)
        publish_success(:check_in, location, card)
      end
    rescue TransitCard::InvalidAction => e
      puts e.message
      publish_failure(location, card)
    end

    # TODO: Figure this out.. switch based on error
    def handle_check_over(card, location)
      card.check_over(location)
      publish_success(:check_in, location, card)
    rescue TransitCard::InvalidAction => e
      puts e.message
      publish_failure(location, card)
    end
  end
end