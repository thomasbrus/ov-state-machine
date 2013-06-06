require 'facets/multiton'

module OVStateMachine
  class Card
    include Multiton
    extend Enumerable

    InsufficientFundsError = Class.new(StandardError)

    attr_reader :id

    def initialize(id)
      @id = id
      @balance = 5.00
      @last_location = nil
    end

    def self.each
      @multiton_instance.values
    end

    def checked_in?
      !checked_out?
    end

    def checked_out?
      @last_location.nil?
    end

    def check_in(carrier, location)
      raise InsufficientFundsError if @balance <= 0
      @last_location = location
    end

    def check_over(location)
      @last_location = location
    end

    def check_out(carrier, location)
      @balance -= carrier.calculate_price(@last_location, location)
      @last_location = nil
    end

    def balance
      @balance.to_i
    end
  end
end
