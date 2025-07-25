class CreateSearchQueries < ActiveRecord::Migration[7.2]
  def change
    create_table :search_queries do |t|
      t.string :term
      t.string :ip_address

      t.timestamps
    end
  end
end
