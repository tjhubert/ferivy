class CreateUsers < ActiveRecord::Migration
  def change
    create_table  :users do |t|
      t.string    :name
      t.string    :phone_number
      t.string    :phone_verification_code
      t.datetime  :phone_verification_code_sent_at
      t.boolean   :phone_verified
      t.datetime  :phone_verified_at

      t.timestamps null: false
    end
    add_index :users, :phone_number, unique: true
  end
end
