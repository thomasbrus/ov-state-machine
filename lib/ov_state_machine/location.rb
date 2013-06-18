module OVStateMachine
  class Location
    include DataMapper::Resource

    property :id,   Serial
    property :name, String
  end
end
