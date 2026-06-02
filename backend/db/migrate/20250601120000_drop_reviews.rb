class DropReviews < ActiveRecord::Migration[7.2]
  def change
    drop_table :reviews, if_exists: true
  end
end
