require 'facets/multiton'

module OVStateMachine
  class Card
    include Multiton
    extend Enumerable

    InvalidAction = Class.new(StandardError)

    attr_reader :id, :balance

    def initialize(id)
      @id = id
      @balance = 5.00
      @last_location, @last_carrier = nil
    end

    def self.each
      @multiton_instance.values
    end

    def checked_in?
      !checked_out?
    end

    def checked_out?
      @last_location.nil? && @last_carrier.nil?
    end

    def check_in(carrier, location)
      raise InvalidAction, "The balance of the card is insufficient." if @balance <= 0
      @last_location, @last_carrier = location, carrier
    end

    def check_over(location)
      raise InvalidAction, "Cannot check over when not checked in." unless checked_in?
      
      if location == @last_location && @last_carrier.tls?
        raise InvalidAction, "Cannot check over twice at the same location."
      end

      check_out(@last_carrier, location)
      check_in(Carrier.new(0), location)
    end

    def check_out(carrier, location)
      unless carrier == @last_carrier || @last_carrier.tls?
        raise InvalidAction, "Cannot check out at this carrier."  
      end

      unless location == @last_location
        @balance -= Carrier.calculate_price(@last_location, location)
      end

      @last_location, @last_carrier = nil
    end
  end
end
