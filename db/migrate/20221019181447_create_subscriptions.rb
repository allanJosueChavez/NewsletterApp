class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.timestamps
    end
    add_reference :subscriptions, :users, foreign_key: true
    add_reference :subscriptions, :newsletters, foreign_key: true
  end
end
