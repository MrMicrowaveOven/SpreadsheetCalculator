class CreateSpreadsheets < ActiveRecord::Migration[5.1]
  def change
    create_table :spreadsheets do |t|
      t.string :instructions

      t.timestamps
    end
  end
end
