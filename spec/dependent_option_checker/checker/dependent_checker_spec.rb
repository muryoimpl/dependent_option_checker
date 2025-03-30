# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DependentOptionChecker::Checker::DependentChecker do
  describe '#extract_unspecified_relations' do
    subject { described_class.new(model).extract_unspecified_relations }

    let(:model) { stub_const('Company', Class.new { |_| def self.pluralize_table_names = 'organizations' }) }

    before do
      allow(model).to receive(:reflections).and_return(
        'organizations' => ActiveRecord::Reflection::HasManyReflection.new(:organizations, nil, options, model)
      )
    end

    context 'when :dependent is not specified' do
      let(:options) { {} }

      it { is_expected.to match_array %w[organizations] }
    end

    context 'when :dependent is specified and value is valid' do
      let(:options) { { dependent: :destroy } }

      it { is_expected.to be_empty }
    end

    context 'when :dependent is specified and value is invalid' do
      let(:options) { { dependent: :invalid } }

      it { is_expected.to match_array %w[organizations] }
    end

    context 'when :dependent is specified and value is nil' do
      let(:options) { { dependent: nil } }

      it { is_expected.to be_empty }
    end
  end
end
