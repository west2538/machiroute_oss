class AddScenarioEndToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :scenario_end, :date
  end
end
