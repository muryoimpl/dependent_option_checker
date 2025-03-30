# frozen_string_literal: true

module DependentOptionChecker
  class ModelLoader
    def self.load_files!
      Rails.autoloaders.main.eager_load_dir(Rails.root.join('app', 'models')) unless Rails.env.production?
    end

    attr_reader :cache_table_attributes

    def initialize(config)
      @config = config
    end

    def application_record_classes
      @application_record_classes ||= ::ApplicationRecord.descendants.filter(&:base_class?)
    end

    def application_table_models
      @application_table_models ||= application_record_classes.reject do |klass|
        next if @config.nil?

        @config.ignored_tables.include?(klass.table_name)
      end
    end

    def load_table_attributes
      @cache_table_attributes = application_table_models.each_with_object({}) do |klass, acc|
        acc[klass.table_name] = klass.attribute_names
      end
    end
  end
end
