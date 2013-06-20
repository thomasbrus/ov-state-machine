require 'singleton'

module OVStateMachine
  class TransitCard
    InvalidAction = Class.new(StandardError)

    include Singleton
    include Journey

    attr_reader :balance

    def initialize
      @balance = 5.00
      @last_location, @last_carrier = nil
    end

    def id
      100 # For now, there is only 1 card
    end

    def checked_in?
      !checked_out?
    end

    def checked_out?
      @last_location.nil? && @last_carrier.nil?
    end

    def check_in(location, carrier)
      raise InvalidAction, "The balance of the card is insufficient." if balance <= 0
      @last_location, @last_carrier = location, carrier
    end

    def check_over(location)
      raise InvalidAction, "Cannot check over when not checked in." unless checked_in?

      if location == @last_location && @last_carrier == Carrier.get(0)
        raise InvalidAction, "Cannot check over twice at the same location."
      end

      check_out(location, @last_carrier)
      check_in(location, Carrier.get(0)) if balance > 0
    end

    def check_out(location, carrier)
      unless carrier == @last_carrier || @last_carrier == Carrier.get(0)
        raise InvalidAction, "Cannot check out at this carrier."
      end

      @balance -= calculate_price(@last_location, location)
      @last_location, @last_carrier = nil
    end
  end
end
