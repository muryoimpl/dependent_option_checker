# frozen_string_literal: true

require 'active_record/reflection'

module DependentOptionChecker
  class Checker
    class RelationDeclarationChecker
      attr_reader :table_cache, :attribute_name

      def initialze(attribute_name:, table_cache:)
        @attribute_name = attribute_name
        @table_cache = table_cache
      end

      def table_names_having_attribute
        table_cache.select do |_, attributes|
          attributes.include?(attribute_name)
        end.keys
      end
    end
  end
end
