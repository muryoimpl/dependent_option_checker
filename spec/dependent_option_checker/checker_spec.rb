# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DependentOptionChecker::Checker do
  describe '#initialize' do
    subject { described_class.new }

    context 'when config file does not exist' do
      it do
        config = subject.instance_variable_get(:@config)

        expect(config.ignored_tables).to match_array(
          %w[ar_internal_metadata schema_migrations]
        )
      end
    end

    context 'when config file does not exist' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it do
        config = subject.instance_variable_get(:@config)
        expect(config).to be_a DependentOptionChecker::Configuration
        expect(config.ignored_tables).to be_empty
      end
    end
  end

  describe '#execute' do
    subject { described_class.new.execute }

    it 'should return data which do not define the dependent option' do
      data = subject.find { |r| r.table_name == 'organizations' }
      expect(data.undeclared).to match_array %w[members]
    end

    it 'should return data which do not define has_one/has_many relation' do
      data = subject.find { |r| r.table_name == 'accounts' }
      expect(data.unspecified).to match_array %w[organizations]
    end

    it do
      data = subject.select { |d| d.unspecified.empty? && d.undeclared.empty? }
      expect(data).to be_empty
    end
  end
end
