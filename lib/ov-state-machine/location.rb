require 'facets/multiton'

module OVStateMachine
  class Location
    include Multiton
    attr_reader :id

    def initialize(id)
      @id = id
    end
  end
end
