class CreateCommitersRepositories < ActiveRecord::Migration
  def change
    create_table :commiters_repositories, :id => false do |t|
      t.references :commiter, :null => false
      t.references :repository, :null => false
    end
  end
end
