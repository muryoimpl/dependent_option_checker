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

      def initialize(model)
        @model = model
      end

      def extract_unspecified_relations
        reflections.filter_map do |reflection|
          option_specified?(reflection.options) ? nil : reflection.name.to_s
        end
      end

      private

      def reflections
        @model.reflections.select do |_, reflection|
          ::DependentOptionChecker::Checker::TARGET_CLASSES.include?(reflection.class)
        end.values
      end

      def option_specified?(options)
        options.key?(:dependent) &&
          (
            DEPENDENT_OPTION_VALUES.include?(options[:dependent]) ||
            options[:dependent].nil?
          )
      end
    end
  end
end
