require 'set'

module OVStateMachine
  class Journey < Struct.new(:origin, :destination)  
    PriceUnknown = Class.new(StandardError)

    PRICE_TABLE = {
      Set[50, 51] => 1.00,
      Set[51, 52] => 2.00,
      Set[50, 52] => 3.00
    }.freeze

    private_constant :PRICE_TABLE

    def calculate_price
      return 0 if origin == destination
      
      PRICE_TABLE.fetch(Set[origin.id, destination.id]) do
        raise PriceUnknown, "Cannot calculate price."
      end
    end
  end
end