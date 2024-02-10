class CreateJokesRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :jokes_requests do |t|
      t.integer :amount, null: false
      t.integer :delay, default: 0

      t.timestamps
    end
  end
end
