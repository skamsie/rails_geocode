class CreateGeocodes < ActiveRecord::Migration[5.2]
  def change
    create_table :geocodes do |t|
      t.string :query, null: false, index: { unique: true }
      t.decimal :latitude
      t.decimal :longitude
      t.string :address
    end
  end
end
