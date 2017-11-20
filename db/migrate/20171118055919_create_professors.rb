class CreateProfessors < ActiveRecord::Migration[5.1]
  def change
    create_table :professors do |t|
      t.string :name
      t.string :age
      t.string :formation_area
      t.belongs_to :university
      t.belongs_to :campus

      t.timestamps
    end
  end
end
