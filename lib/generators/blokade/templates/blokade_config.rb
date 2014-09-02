# # config/initializers/blokade.rb
Blokade.configure do |config|

  # Set this to specify your own implementation of Role
  config.role_class = 'Role'

  # Set this to specify your own implementation of User
  config.user_class = 'User'

  # Set this to specify what Blokade should limit the permissions to (i.e. Company, School)
  config.blokadable_class = 'Company'

  # Set this to specify the default blokades which Blokade should generate for a model
  config.default_blokades = [:manage, :index, :show, :new, :create, :edit, :update, :destroy]

  # Specify which models will call `blokades frontend: [...]`
  # This is required in order for Blokade to generate permissions
  config.armada = ["Role", "User", "Company", "Lead", "InvalidConstant"]

  # Add hash entries to this array to specify directives for managing frontend symbolic permissions
  config.symbolic_frontend_blokades = [{manage: :my_custom_engine}]

end
