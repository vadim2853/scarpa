class UpdateExistAndAddNewRolesToSpreeRoles < ActiveRecord::Migration
  def up
    Rake::Task['db:ensure_roles_for_spree_roles'].invoke
  end

  def down
    Rake::Task['db:turn_back_default_spree_roles'].invoke
  end
end
