class ChangeField < ActiveRecord::Migration
  def up
    rename_column :users, :password_digest, :encrypted_password
  end

  def down
  end
end
