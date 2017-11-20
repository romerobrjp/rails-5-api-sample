class CreateProfessorsDisciplines < ActiveRecord::Migration[5.1]
  def change
    create_table :professors_disciplines do |t|
      t.belongs_to :professor, index: true
      t.belongs_to :discipline, index: true
    end
  end
end
