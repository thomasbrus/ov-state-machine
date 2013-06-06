module OVStateMachine
  module Reporters
    class ReaderStatus < Reporter
      SUCCESSFUL_CHECKIN = 1
      SUCCESSFUL_CHECKOUT = 0
      UNSUCCESFUL_ACTION = -1

      def action_name
        "reader_status"
      end

      def report_check_in(card_id, balance)
        report(card_id, SUCCESSFUL_CHECKIN, balance)
      end

      def report_check_out(card_id, balance)
        report(card_id, SUCCESSFUL_CHECKOUT, balance)
      end

      def report_failure(card_id, balance)
        report(card_id, UNSUCCESFUL_ACTION, balance)
      end
    end
  end
end
