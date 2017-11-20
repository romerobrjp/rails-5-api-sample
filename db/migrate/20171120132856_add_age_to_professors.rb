class AddAgeToProfessors < ActiveRecord::Migration[5.1]
  def change
    add_column :professors, :age, :integer
  end
end
