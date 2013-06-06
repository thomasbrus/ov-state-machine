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
        method = if carrier.tls?
          card.check_over(location)
          :report_check_in
        elsif card.checked_in?
          card.check_out(carrier, location)
          :report_check_out
        elsif card.checked_out?
          card.check_in(carrier, location)
          :report_check_in
        end

        reporter.send(method, card.id, card.balance)
      rescue Card::InvalidAction
        reporter.report_failure(card.id, card.balance)
      end

      def reporter
        @reader_status_reporter ||= Reporters::ReaderStatus.new
      end
    end
  end
end
