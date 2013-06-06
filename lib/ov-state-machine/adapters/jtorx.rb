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
        args.zip([Card, Carrier, Location]).map { |id, klass| klass.new(id.to_i) }
      end

      def handle_show(card, carrier, location)
        if carrier.tls?
          card.check_over(location)
          # TODO: Report either check in or check out.
          reporter.report_failure(card.id, card.balance)
        elsif card.checked_in?
          card.check_out(carrier, location)
          reporter.report_check_out(card.id, card.balance)
        else
          card.check_in(carrier, location)
          reporter.report_check_in(card.id, card.balance)
        end
      rescue Card::InsufficientFundsError, InvalidCarrierError
        reporter.report_failure(card.id, card.balance)
      end

      def reporter
        @reader_status_reporter ||= Reporters::ReaderStatus.new
      end
    end
  end
end
