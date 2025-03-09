# frozen_string_literal: true

require_relative 'dependent_option_checker/version'
require_relative 'dependent_option_checker/checker'

module DependentOptionChecker
  class Error < StandardError; end
end

require_relative 'dependent_option_checker/railtie'
