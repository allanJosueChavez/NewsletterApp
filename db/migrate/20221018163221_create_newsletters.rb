class CreateNewsletters < ActiveRecord::Migration[7.0]
  def change
    create_table :newsletters do |t|
      t.string :topic, default: ""
      t.string :name, default: ""
      t.string :description, default: ""
      t.boolean :t_rated, default: false
      t.timestamps
    end
  end
end
