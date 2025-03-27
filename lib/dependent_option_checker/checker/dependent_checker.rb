# frozen_string_literal: true

require 'active_record/reflection'

module DependentOptionChecker
  class Checker
    class DependentChecker
      DEPENDENT_OPTION_VALUES = %i[
        destroy
        destroy_async
        delete_all
        nullify
        restrict_with_exception
        restrict_with_error
      ].freeze

      def self.dependent_option_specified?(options)
        options.key?(:dependent) &&
          (
            DEPENDENT_OPTION_VALUES.include?(options[:dependent]) ||
            options[:dependent].nil?
          )
      end
    end
  end
end
