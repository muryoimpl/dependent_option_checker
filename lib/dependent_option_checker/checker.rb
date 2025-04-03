# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/module/delegation'
require 'active_record'

require_relative 'configuration'
require_relative 'model_loader'
require_relative 'checker/dependent_checker'
require_relative 'checker/relation_declaration_checker'

module DependentOptionChecker
  class Checker
    TARGET_CLASSES = [
      ActiveRecord::Reflection::HasOneReflection,
      ActiveRecord::Reflection::HasManyReflection
    ].freeze

    def initialize
      super
      @config = Configuration.load
    end

    def execute
      ModelLoader.load_files!

      model_loader.load_table_attributes

      model_loader.application_record_classes.each_with_object([]) do |model, acc|
        unspecified = dependent_checker(model).extract_unspecified_relations
        undeclared = relation_declaration_checker(model).extract_undeclared_tables

        next if unspecified.empty? && undeclared.empty?

        acc << result.new(model_name: model.name, table_name: model.table_name, unspecified:, undeclared:)
      end
    end

    private

    def model_loader
      @model_loader ||= ModelLoader.new(@config)
    end

    def dependent_checker(model)
      DependentChecker.new(model)
    end

    def relation_declaration_checker(model)
      RelationDeclarationChecker.new(
        model:,
        table_cache: model_loader.cache_table_attributes,
        ignored_relations: @config.ignored_relations[model.name]
      )
    end

    def result
      @result ||= Data.define(:model_name, :table_name, :unspecified, :undeclared)
    end
  end
end
