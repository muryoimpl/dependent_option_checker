# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DependentOptionChecker::Checker::DependentChecker do
  describe '#execute' do
    let(:klass) { Class.new }

    subject do
      checker.execute
      checker
    end

    context 'when specifying dependent option' do
      let(:checker) { described_class.new(klass, {}) }
      let(:dependent_value) { :destroy }

      before do
        allow(klass).to receive(:reflections).and_return(
          {
            'organizations' => ActiveRecord::Reflection::HasManyReflection.new(
              'organizations', nil, { dependent: dependent_value }, Organization
            )
          }
        )
      end

      context 'when option is dependent: :destory' do
        let(:dependent_value) { :destroy }
        it { is_expected.to be_valid }
      end

      context 'when option is dependent: :destroy_async' do
        let(:dependent_value) { :destroy_async }
        it { is_expected.to be_valid }
      end

      context 'when option is dependent: :delete_all' do
        let(:dependent_value) { :delete_all }
        it { is_expected.to be_valid }
      end

      context 'when option is dependent: :nullify' do
        let(:dependent_value) { :nullify }
        it { is_expected.to be_valid }
      end
      context 'when option is dependent: :restrict_with_exception' do
        let(:dependent_value) { :restrict_with_exception }
        it { is_expected.to be_valid }
      end

      context 'when option is dependent: :restrict_with_error' do
        let(:dependent_value) { :restrict_with_error }
        it { is_expected.to be_valid }
      end

      context 'when option is dependent: nil' do
        let(:dependent_value) { nil }
        it { is_expected.to be_valid }
      end

      context 'when option is unknown value' do
        let(:dependent_value) { :unknown }
        it { is_expected.to be_invalid }
      end
    end

    context 'when instance is not in target classes' do
      let(:checker) { described_class.new(klass, {}) }

      before do
        allow(klass).to receive(:reflections).and_return(
          {
            'organizations' => ActiveRecord::Reflection::ThroughReflection.new(
              ActiveRecord::Reflection::HasManyReflection.new(
                'members', nil, {}, Member
              )
            )
          }
        )
      end

      it { is_expected.to be_valid }
    end

    context 'when not specifying dependent option on has_many' do
      let(:checker) { described_class.new(klass, {}) }

      before do
        allow(klass).to receive(:reflections).and_return(
          {
            'organizations' => ActiveRecord::Reflection::HasManyReflection.new(
              'organizations', nil, {}, Organization
            )
          }
        )
      end

      it { is_expected.to be_invalid }
    end

    context 'when not specifying dependent option on has_one' do
      let(:checker) { described_class.new(klass, {}) }

      before do
        allow(klass).to receive(:reflections).and_return(
          {
            'account' => ActiveRecord::Reflection::HasOneReflection.new(
              'account', nil, {}, Account
            )
          }
        )
      end

      it { is_expected.to be_invalid }
    end
  end
end
