# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :organizations, foreign_key: :owner_account_id
end
