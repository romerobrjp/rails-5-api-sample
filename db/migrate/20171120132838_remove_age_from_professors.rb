class RemoveAgeFromProfessors < ActiveRecord::Migration[5.1]
  def change
    remove_column :professors, :age, :string
  end
end
