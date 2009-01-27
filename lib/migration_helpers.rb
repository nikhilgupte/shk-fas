module MigrationHelpers
  def foreign_key(from_table, from_column, to_table, cascade_delete = true, cascade_upate = true)
    constraint_name = "fk_#{from_table}_#{from_column}" 
    delete_action = cascade_delete ? 'cascade' : 'no action'
    update_action = cascade_upate ? 'cascade' : 'no action'

    execute %{alter table #{from_table}
              add constraint #{constraint_name}
              foreign key (#{from_column})
              references #{to_table}(id) on delete #{delete_action} on update #{update_action}}
  end
end
