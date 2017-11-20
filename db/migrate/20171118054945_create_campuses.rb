class CreateCampuses < ActiveRecord::Migration[5.1]
  def change
    create_table :campuses do |t|
      t.string :name
      t.string :city
      t.belongs_to :university
      t.timestamps
    end
  end
end
