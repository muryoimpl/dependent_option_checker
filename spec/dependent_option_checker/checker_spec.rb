# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DependentOptionChecker::Checker do
  describe '#initialize' do
    subject { described_class.new }

    context 'when config file does not exist' do
      it do
        config = subject.instance_variable_get(:@config)[:ignored_tables]

        expect(config).to match_array(
          %w[ar_internal_metadata schema_migrations]
        )
      end
    end

    context 'when config file does not exist' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it do
        expect(subject.instance_variable_get(:@config)).to be_empty
      end
    end
  end

  describe '#execute' do
    # TODO: implement tests
  end
end
