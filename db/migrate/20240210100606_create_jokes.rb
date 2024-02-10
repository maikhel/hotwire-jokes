class CreateJokes < ActiveRecord::Migration[7.1]
  def change
    create_table :jokes do |t|
      t.string :body
      t.references :jokes_request, foreign_key: true

      t.timestamps
    end
  end
end
