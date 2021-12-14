class CreateFrases < ActiveRecord::Migration[6.1]
  def change
    create_table :frases do |t|
      t.string :quote
      t.string :author
      t.string :author_about

      t.timestamps
    end
  end
end
