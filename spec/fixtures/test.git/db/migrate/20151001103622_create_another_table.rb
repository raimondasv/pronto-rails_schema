class CreateAnotherTable < ActiveRecord::Migration
  def change
    create_table :another_tables do |t|
      t.string :title
    end
  end
end
