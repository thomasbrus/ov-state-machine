require 'set'
require 'facets/multiton'

module OVStateMachine
  module Core
    class Carrier < Struct.new(:id)
      include Multiton
      TLS = Carrier.new(0)
    end    
  end
end
