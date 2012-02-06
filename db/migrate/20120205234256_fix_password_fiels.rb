class FixPasswordFiels < ActiveRecord::Migration
  def up
    rename_column :users, :encrypted_password, :password_digest
  end

  def down
  end
end
