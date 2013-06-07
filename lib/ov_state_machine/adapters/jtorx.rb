module OVStateMachine
  module Adapters
    class JTorX < Adapter
      def run
        super do |line|
          action, *args = decode(line)
          *parsed_args = send("parse_#{action}", *args)
          send("handle_#{action}", *parsed_args)
        end
      end

      private

      def decode(line)
        line.split('!').map(&:strip)
      end

      def parse_show(*args)
        [Card, Carrier, Location].zip(args).map { |klass, id| klass.new(id.to_i) }
      end

      def handle_show(card, carrier, location)
        if carrier.tls?
          card.check_over(location)
          reporter.report_check_in(card.id, card.balance)
        else
          method = (card.checked_in? ? :check_out : :check_in)
          card.send(method, carrier, location)
          reporter.send("report_#{method}", card.id, card.balance)
        end
      rescue Card::InvalidAction
        reporter.report_failure(card.id, card.balance)
      end

      def reporter
        @reader_status_reporter ||= Reporters::ReaderStatus.new
      end
    end
  end
end
