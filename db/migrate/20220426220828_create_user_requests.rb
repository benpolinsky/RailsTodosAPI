class CreateUserRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :user_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :action

      t.timestamps
    end
  end
end
