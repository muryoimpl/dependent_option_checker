# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DependentOptionChecker::Configuration do
  describe '.load' do
    subject { described_class.load }

    it { is_expected.to be_a(described_class) }
  end

  describe '#ignored_tables' do
    subject { described_class.new.ignored_tables }

    context 'when config file is blank' do
      before do
        allow_any_instance_of(described_class).to receive(:config_file_path).and_return('./fake.yml')
      end

      it { is_expected.to be_empty }
    end

    context 'when config file exists' do
      before do
        allow_any_instance_of(described_class).to receive(:load_config).and_return(
          'ignored_tables' => %w[organizations]
        )
      end

      it { is_expected.to eq %w[organizations] }
    end
  end

  describe '#ignored_relations' do
    subject { described_class.new.ignored_relations }

    context 'when config file is blank' do
      before do
        allow_any_instance_of(described_class).to receive(:config_file_path).and_return('./fake.yml')
      end

      it { is_expected.to be_empty }
    end

    context 'when config file exists' do
      before do
        allow_any_instance_of(described_class).to receive(:load_config).and_return(
          'ignored_relations' => { 'Organization' => %w[employees] }
        )
      end

      it { is_expected.to eq('Organization' => %w[employees]) }
    end
  end
end
