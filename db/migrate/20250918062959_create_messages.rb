class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.text :content, null: false

      t.references :sender, null: false, foreign_key: { to_table: :users}
      t.references :receiver, null: false, foreign_key: { to_table: :users}

      t.references :reply_to, foreign_key: { to_table: :messages}

      t.timestamps
    end
    add_index :messages, [:sender_id, :receiver_id]
  end
end
