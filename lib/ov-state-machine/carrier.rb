require 'facets/multiton'

module OVStateMachine
  class Carrier
    include Multiton
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def calculate_price(location_a, location_b)
      1.00
    end

    def tls?
      @id == 0
    end
  end
end
