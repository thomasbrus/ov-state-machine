require 'set'
require 'facets/multiton'

module OVStateMachine
  class Carrier
    include Multiton
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def self.calculate_price(location_a, location_b)
      { Set[50, 51] => 1.00,
        Set[51, 52] => 2.00,
        Set[50, 52] => 3.00
      }.fetch(Set[location_a.id, location_b.id])
    end

    def tls?
      @id == 0
    end
  end
end
