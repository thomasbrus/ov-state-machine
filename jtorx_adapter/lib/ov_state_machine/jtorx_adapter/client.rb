require 'socket'

module OVStateMachine
  module JTorXAdapter
    class Client
      def initialize
        @socket = TCPSocket.new
      end
    end
  end
end
