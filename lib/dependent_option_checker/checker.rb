# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/module/delegation'
require 'active_record'

module DependentOptionChecker
  class Checker
    def initialize
      super
      @config = if File.exist?(config_file_path)
                  load_config
                else
                  {}
                end
    end

    def execute
      # TODO: implement it
    end

    private

    def config_file_path = Rails.root.join('.dependent_option_checker.yml')

    def load_config
      YAML.safe_load_file(config_file_path, symbolize_names: true)
    end

    def table_names
      ActiveRecord::Base.connection.tables - ignored_tables
    end

    def ignored_tables
      @config[:ignored_tables]
    end
  end
end
