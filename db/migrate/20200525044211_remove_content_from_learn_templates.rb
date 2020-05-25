class RemoveContentFromLearnTemplates < ActiveRecord::Migration[6.0]
  def change
    remove_column :learn_templates, :content, :text
  end
end
