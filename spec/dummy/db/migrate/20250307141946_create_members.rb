# frozen_string_literal: true

class CreateMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :members do |t|
      t.references :organization
      t.string :name, null: false

      t.timestamps
    end
  end
end
