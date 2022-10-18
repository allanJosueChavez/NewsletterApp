class AlterNewsletters < ActiveRecord::Migration[7.0]
  def change
  end
  add_reference :newsletters, :users, foreign_key: true
  add_reference :posts, :users, foreign_key: true
  add_reference :posts, :newsletters, foreign_key: true
end
