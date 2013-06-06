module OVStateMachine
  class Adapter
    attr_reader :input

    def initialize(input = $stdin)
      @input = input
    end

    private

    def run(&block)
      while line = @input.gets
        block.call(line)
      end
    end
  end
end
