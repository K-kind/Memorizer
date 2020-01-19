class CreateLearnTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :learn_templates do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
