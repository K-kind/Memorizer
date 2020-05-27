class CreateReleaseNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :release_notes do |t|
      t.text :content
      t.string :version
      t.date :release_date

      t.timestamps
    end
  end
end
