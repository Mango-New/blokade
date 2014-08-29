Blokade.setup do |config|
  # Specify which models will call `blokades frontend: [...]`
  # This is required in order for Blokade to generate permissions
  config.armada = ["Role", "User", "Company", "Lead", "InvalidConstant"]

  config.power_class = "Blokade::Power"
  config.grant_class = "Blokade::Grant"
  config.permission_class = "Blokade::Permission"

  # Set this to specify your own implementation of Role
  config.role_class = "Role"

  # Set this to specify your own implementation of User
  config.user_class = "User"

  # Set this to specify what Blokade should limit the permissions to (i.e. Company, School)
  config.blockadable_class = "Company"

  # Set this to specify the default blokades which Blokade should generate for a model
  config.default_blokades = [:manage, :index, :show, :new, :create, :edit, :update, :destroy]

  # Add hash entries to this array to specify directives for managing frontend symbolic permissions
  config.symbolic_frontend_blokades = [{manage: :my_custom_engine}]
end
