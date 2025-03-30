# frozen_string_literal: true

module DependentOptionChecker
  class Configuration
    def self.load = new

    def initialize
      @config = if File.exist?(config_file_path)
                  load_config
                else
                  {}
                end
    end

    def ignored_tables = @config[:ignored_tables] || []

    private

    def config_file_path = Rails.root.join('.dependent_option_checker.yml')

    def load_config = YAML.safe_load_file(config_file_path, symbolize_names: true)
  end
end
