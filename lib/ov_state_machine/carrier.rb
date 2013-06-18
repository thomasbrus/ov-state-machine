module OVStateMachine
  class Carrier
    include DataMapper::Resource

    property :id,   Serial
    property :name, String
  end
end
