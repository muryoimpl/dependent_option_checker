# frozen_string_literal: true

require 'rails/generators'

module DependentOptionChecker
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_yml_file
      copy_file 'dependent_option_checker.yml', 'config/dependent_option_checker.yml'
    end
  end
end
