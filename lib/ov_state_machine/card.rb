require 'facets/multiton'

module OVStateMachine
  class Card
    include Multiton
    extend Enumerable

    InsufficientFundsError = Class.new(StandardError)
    InvalidCarrierError = Class.new(StandardError)

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
      raise InsufficientFundsError if @balance <= 0
      @last_location, @last_carrier = location, carrier
    end

    def check_over(location)
      @last_location = location
    end

    def check_out(carrier, location)
      raise InvalidCarrierError unless carrier == @last_carrier
      @balance -= Carrier.calculate_price(@last_location, location)
      @last_location, @last_carrier = nil
    end
  end
end
