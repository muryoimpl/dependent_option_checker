# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DependentOptionChecker::ModelLoader do
  describe '.load_files!' do
    subject { described_class.load_files! }

    before do
      allow(Rails).to receive_message_chain('root', 'join').with('app', 'models').and_return('app/models')
      allow(Rails).to receive_message_chain('autoloaders', 'main', 'eager_load_dir')
    end

    it do
      expect(Rails).to receive_message_chain('root', 'join').with('app', 'models')
      expect(Rails).to receive_message_chain('autoloaders', 'main', 'eager_load_dir').with('app/models')

      subject
    end
  end

  describe '#applicaiton_record_classes' do
    subject { described_class.new({}).application_record_classes }

    before do
      described_class.load_files!
    end

    it { is_expected.to match_array [Organization, Member, Account] }
  end

  describe '#application_table_models' do
    subject { described_class.new(config).application_table_models }

    context 'when config is nil' do
      let(:config) { nil }

      it { is_expected.to match_array [Organization, Member, Account] }
    end

    context 'when config is blank' do
      let(:config) { instance_double(DependentOptionChecker::Configuration, ignored_tables: []) }

      it { is_expected.to match_array [Organization, Member, Account] }
    end

    context 'when config[:ignored_tables] is set' do
      let(:config) { instance_double(DependentOptionChecker::Configuration, ignored_tables: ['organizations']) }

      it { is_expected.to match_array [Member, Account] }
    end
  end
end
