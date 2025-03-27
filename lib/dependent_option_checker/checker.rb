# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/module/delegation'
require 'active_record'

require_relative 'checker/dependent_checker'

module DependentOptionChecker
  class Checker
    TARGET_CLASSES = [
      ActiveRecord::Reflection::HasOneReflection,
      ActiveRecord::Reflection::HasManyReflection
    ].freeze

    def initialize
      super
      @config = if File.exist?(config_file_path)
                  load_config
                else
                  {}
                end
    end

    def execute
      load_model_files unless Rails.env.production?

      cache_table_attributes

      application_record_classes.each do |model|
        specified = []
        unspecified = []

        reflections = has_x_refletions(model)
        reflections.each_value do |reflection|
          if DependentChecker.dependent_option_specified?(reflection.options)
            specified << reflection
          else
            unspecified << reflection
          end
        end

        #       attribute_id = target_attribute_name
        #       tables_having_attribute = cache_table_attributes.select do |_, attributes|
        #         attributes.include?(attribute_id)
        #       end

        #       relation_declaration_checker = RelationDeclarationChecker.new(model, @config, @cache_table_attributes)
        #       relation_declaration_checker.execute
      end
    end

    private

    def config_file_path = Rails.root.join('.dependent_option_checker.yml')

    def load_config
      YAML.safe_load_file(config_file_path, symbolize_names: true)
    end

    def ignored_tables
      @config[:ignored_tables]
    end

    def application_record_classes
      @application_record_classes ||= ::ApplicationRecord.descendants.filter(&:base_class?)
    end

    def application_table_models
      @application_table_models ||= application_record_classes.reject do |klass|
        ignored_tables.include?(klass.table_name)
      end
    end

    #   def application_tables
    #     application_record_classes.map(&:table_name) - ignored_tables
    #   end

    def cache_table_attributes
      @cache_table_attributes ||= application_table_models.each_with_object({}) do |klass, acc|
        acc[klass.table_name] = klass.attribute_names
      end
    end

    def load_model_files!
      Rails.autoloads.main.eager_load_dir(Rails.root.join('app', 'models'))
    end

    def target_attribute_name
      "#{model.table_name.singularize.undersocre}_id"
    end

    def has_x_refletions(model)
      model.reflections.select do |reflection|
        TARGET_CLASSES.include?(reflection.class)
      end
    end
  end
end
