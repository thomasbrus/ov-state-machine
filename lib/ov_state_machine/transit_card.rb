require 'json'
require 'facets/multiton'

module OVStateMachine
  class TransitCard
    include Multiton
    InvalidAction = Class.new(StandardError)

    attr_reader :id, :balance

    def initialize(id)
      @id = id
      @balance = 5.00
      @last_location, @last_carrier = nil
    end

    def checked_in?
      !checked_out?
    end

    def checked_out?
      @last_location.nil? && @last_carrier.nil?
    end

    def check_in(carrier, location)
      raise InvalidAction, "The balance of the card is insufficient." if balance <= 0
      @last_location, @last_carrier = location, carrier
    end

    def check_over(location)
      raise InvalidAction, "Cannot check over when not checked in." unless checked_in?
      
      if location == @last_location && @last_carrier == Carrier::TLS
        raise InvalidAction, "Cannot check over twice at the same location."
      end

      check_out(@last_carrier, location)    
      check_in(Carrier::TLS, location)
    end

    def check_out(carrier, location)
      unless carrier == @last_carrier || @last_carrier == Carrier::TLS
        raise InvalidAction, "Cannot check out at this carrier."  
      end

      @balance -= Journey.new(@last_location, location).calculate_price
      @last_location, @last_carrier = nil
    end
  end
end