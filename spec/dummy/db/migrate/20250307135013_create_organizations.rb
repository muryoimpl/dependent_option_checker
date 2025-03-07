# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.references :owner_account, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
