# frozen_string_literal: true

require 'active_record/reflection'
require 'active_support/core_ext/string'

module DependentOptionChecker
  class Checker
    class RelationDeclarationChecker
      def initialize(model:, table_cache:)
        @model = model
        @table_cache = table_cache
      end

      def extract_undeclared_tables
        tables = table_names_having_attribute
        tables - relation_table_names
      end

      private

      def table_names_having_attribute
        @table_cache.select do |_, attributes|
          attributes.include?(attribute_name)
        end.keys
      end

      def attribute_name
        @attribute_name ||= "#{@model.table_name.singularize.underscore}_id"
      end

      def relation_table_names
        @model.reflections.select do |_, relation|
          ::DependentOptionChecker::Checker::TARGET_CLASSES.include?(relation.class)
        end.values.map(&:plural_name)
      end
    end
  end
end
