class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :twitterUrl
      t.string :twitterName
      t.string :description
      t.string :profilePicUrl
      t.string :coverPicUrl

      t.timestamps
    end
  end
end
