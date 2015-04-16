module Blokade
  module Helpers
    def tables_exist
      ActiveRecord::Base.connection.table_exists? 'blokade_grants'
      and ActiveRecord::Base.connection.table_exists? 'blokade_permissions'
      and ActiveRecord::Base.connection.table_exists? 'blokade_powers''
    end
  end
end
