require 'facets/multiton'

module OVStateMachine
  class Location < Struct.new(:id)
    include Multiton
  end
end
