class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :uid
      t.string :provider
      t.string :authentication_token

      t.timestamps
    end
  end
end
