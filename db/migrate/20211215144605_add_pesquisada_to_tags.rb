class AddPesquisadaToTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :pesquisada, :boolean
  end
end
