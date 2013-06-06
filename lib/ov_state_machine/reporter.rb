module OVStateMachine
  class Reporter
    def initialize(output = $stdout)
      @output = output
    end

    def action_name
      raise NotImplementedError, "Sub class must implement this method"
    end

    def report(*args)
      @output.puts(encode(action_name, *args))
      @output.flush
    end

    private

    def encode(action, *args)
      [action, *args].join('!')
    end
  end
end
