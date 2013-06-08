require 'set'
require 'facets/multiton'

module OVStateMachine
  class Carrier < Struct.new(:id)
    include Multiton

    TLS = Carrier.new(0)

    def tls?
      id == 0
    end
  end
end
