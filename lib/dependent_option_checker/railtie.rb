# frozen_string_literal: true

require 'rails/railtie'

module DependentOptionChecker
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'dependent_option_checker/tasks/dependent_option_checker.rake'
    end
  end
end
