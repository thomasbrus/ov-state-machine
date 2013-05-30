require 'state_machine/core'

module OVStateMachine
  class Simulator
    extend StateMachine::MacroMethods

    state_machine :state, :initial => :checked_out do
      event :check_in do
        transition :checked_out => :checked_in
      end

      event :check_over do
        transition :checked_in => :checked_over
      end

      event :check_out do
        transition [:checked_in, :checked_over] => :checked_out
      end
    end
  end
end
