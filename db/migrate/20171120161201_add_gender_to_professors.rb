class AddGenderToProfessors < ActiveRecord::Migration[5.1]
  def change
    add_column :professors, :gender, :string
  end
end
