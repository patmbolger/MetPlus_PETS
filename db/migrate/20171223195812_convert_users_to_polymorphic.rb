class ConvertUsersToPolymorphic < ActiveRecord::Migration
  change_table :users do |t|
    t.rename :actable_id, :person_id
    t.rename :actable_type, :person_type
  end

  add_index :users, [:person_type, :person_id]
end
