require 'facets/multiton'

module OVStateMachine
  module Core
    class Location < Struct.new(:id)
      include Multiton
    end
  end
end
