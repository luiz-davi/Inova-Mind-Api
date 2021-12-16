class CreateTagfrases < ActiveRecord::Migration[6.1]
  def change
    create_table :tagfrases do |t|
      t.belongs_to :tag, null: false, foreign_key: true
      t.belongs_to :frase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
