# frozen_string_literal: true

require 'active_record/reflection'

module DependentOptionChecker
  class Checker
    class DependentChecker
      TARGET_CLASSES = [
        ActiveRecord::Reflection::HasOneReflection,
        ActiveRecord::Reflection::HasManyReflection
      ].freeze
      DEPENDENT_OPTION_VALUES = %i[
        destroy
        destroy_async
        delete_all
        nullify
        restrict_with_exception
        restrict_with_error
      ].freeze

      attr_reader :model_class

      def initialize(model_class, config)
        super()
        @model_class = model_class
        @config = config
        @valid = true
      end

      def execute
        model_class.reflections.each_value do |reflection|
          next unless TARGET_CLASSES.include?(reflection.class)
          next if dependent_option_specified?(reflection.options)

          @valid = false
          # TODO: 設定漏れを出力する
        end
        # TODO: どのテーブルのどのリレーションが設定漏れかを出力する
      end

      def valid? = @valid
      def invalid? = !@valid

      private

      def dependent_option_specified?(options)
        options.key?(:dependent) &&
          (
            DEPENDENT_OPTION_VALUES.include?(options[:dependent]) ||
            options[:dependent].nil?
          )
      end
    end
  end
end
