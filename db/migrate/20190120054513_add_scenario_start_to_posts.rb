class AddScenarioStartToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :scenario_start, :date
  end
end
