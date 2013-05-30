module OVStateMachine
  module Adapters
    class JTorX
      def initialize(state_machine, input = STDIN, output = STDOUT)
        @state_machine = state_machine
        @input, @output = input, output
        run
      end

      private

      def run
        while event = @input.gets.chomp
          @state_machine.fire_state_event(event)
          @state_machine.state_events.each do |event|
            @output.puts event
          end
        end
      end
    end
  end
end
