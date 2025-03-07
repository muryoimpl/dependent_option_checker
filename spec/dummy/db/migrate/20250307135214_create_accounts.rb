# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.string :email, null: false

      t.timestamps
    end
  end
end
