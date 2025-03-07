# frozen_string_literal: true

class Organization < ApplicationRecord
  # has_many :members NOTE: Dare to comment it out
  belongs_to :owner_account, class_name: 'Account'
end
