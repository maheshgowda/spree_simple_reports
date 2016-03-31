module Spree
  module Admin
    ReportsController.class_eval do

      module SimpleReport
        def initialize
          ReportsController.add_available_report!(:ten_days_order_count)
          ReportsController.add_available_report!(:thirty_days_order_count)
          super
        end
      end
      prepend SimpleReport

      # load helper method to views & controller
      helper "spree/admin/simple_reports"
      include SimpleReportsHelper

      def ten_days_order_count
        @counts = n_day_order_count(7)
      end

      def thirty_days_order_count
        @counts = n_day_order_count(30)
      end

      private

      def n_day_order_count(n)
        counts = []
        n.times do |i|
          counts << {
            number: i,
            date: i.days.ago.to_date,
            count: Order.complete
              .where("completed_at >= ?",i.days.ago.beginning_of_day)
              .where("completed_at <= ?",i.days.ago.end_of_day).count
          }
        end
        counts
      end

      def store_id
        params[:store_id].presence
      end

      def completed_at_gt
        params[:completed_at_gt] = if params[:completed_at_gt].blank?
          Date.today.beginning_of_month
        else
          Date.parse(params[:completed_at_gt])
        end
      end

      def completed_at_lt
        params[:completed_at_lt] = if params[:completed_at_lt].blank?
          Date.today
        else
          Date.parse(params[:completed_at_lt])
        end
      end

    end
  end
end
