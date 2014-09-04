Blokade.configure do |config|

  # Set this to specify your own implementation of Role
  config.role_class = 'Role'

  # Set this to specify your own implementation of User
  config.user_class = 'User'

  # Set this to specify what Blokade should limit the permissions to (i.e. Company, School)
  config.blokadable_class = 'Company'

  # Set this to specify the default blokades which Blokade should generate for a model
  config.default_blokades = [:manage, :index, :show, :new, :create, :edit, :update, :destroy]

  # Add hash entries to this array to specify directives for managing frontend symbolic permissions
  config.symbolic_frontend_blokades = [{manage: :my_custom_engine}]

  # Indicate that a User can belong to multiple companies
  config.one_to_one_user_associations = true

  # Set the default limiting column
  config.blokade_id_column = "company"

  # Start integrating Roadblock
  config.harbor.setup do |setup|
    # Company Frontend
    setup.add_barrier "Company", i18n: true do
      barriers [:show, :edit, :update], convoy: :frontend
    end

    # Company Backend
    setup.add_barrier "Company", i18n: true do
      barriers [:manage], convoy: :backend
    end

    # User Frontend
    setup.add_barrier "User", i18n: false do
      barriers [:manage, :index, :show, :new, :create, :edit, :update, :destroy], convoy: :frontend
    end

    # User Backend
    setup.add_barrier "User", i18n: false do
      barriers [:manage], convoy: :backend
    end

    # Role Frontend
    setup.add_barrier "Role", i18n: false do
      barriers [:manage, :index, :show, :new, :create, :edit, :update, :destroy], convoy: :frontend
    end

    # Role Backend
    setup.add_barrier "Role", i18n: false do
      barriers [:manage], convoy: :backend
    end

    # User
    setup.add_barrier "User", i18n: false do
      barriers [:manage], convoy: :backend
    end

    # Lead Frontend
    setup.add_barrier "Lead", i18n: false do
      barriers [:manage], convoy: :frontend, restrict: :assignable_id
    end

    # Lead Backend
    setup.add_barrier "Lead", i18n: false do
      barriers [:manage], convoy: :backend
    end
  end

end
