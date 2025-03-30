# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DependentOptionChecker::Checker::RelationDeclarationChecker do
  describe '#extract_undeclared_tables' do
    subject { described_class.new(model:, table_cache:).extract_undeclared_tables }

    let(:model) do
      stub_const('Organization', Class.new do |_|
        def self.pluralize_table_names = 'organizations'
        def self.table_name = 'organizations'
      end)
    end
    let(:department) do
      stub_const('Department', Class.new do |_|
        def self.pluralize_table_names = 'departments'
      end)
    end
    let(:reflections) { {} }

    before do
      allow(model).to receive(:reflections).and_return(reflections)
    end

    context 'when there is/are table(s) having the "<model_name>_id" and it defines relation(s) in that model' do
      let(:table_cache) do
        {
          'organizations' => %w[id name],
          'departments' => %w[id name organization_id]
        }
      end
      let(:reflections) do
        { 'departments' => ActiveRecord::Reflection::HasManyReflection.new(:departments, nil, {}, department) }
      end

      it { is_expected.to be_empty }
    end

    context 'when there is/are table(s) having the "<model_name>_id" but it does not define relation in that model' do
      let(:table_cache) do
        {
          'organizations' => %w[id name],
          'departments' => %w[id name organization_id]
        }
      end

      it { is_expected.to match_array %w[departments] }
    end

    context 'when there is no table having the "<model_name>_id" attribute' do
      let(:table_cache) do
        {
          'organizations' => %w[id name]
        }
      end

      it { is_expected.to be_empty }
    end
  end
end
