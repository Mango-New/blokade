# Blokade Engine

## Purpose

This rails gem engine is used for integrating with CanCan. It allows the permissions to be stored
inside the database, rather than inside a flat file. It creates a distinct separation between
frontend vs. backend permissions.


### Installation

```ruby
gem 'blokade', git: 'https://github.com/PhoenixfireDevelopment/blokade.git'
```

### Copy Migrations

Blokade requires that you copy the database migrations in the following fashion:

```ruby
rake blokade:install:migrations
```

### Configuration

Blokade can be configured via an initializer file in the following fashion:

```ruby
# config/initializers/blokade.rb

Blokade.setup do |config|
  # Specify which models will call `blokades frontend: [...]`
  # This is required in order for Blokade to generate permissions
  config.armada = ["Role", "User", "Company"]

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
```

### Mount the Engine

Blokade needs to be mounted inside the routes file. Add the following line where appropriate:

```ruby
mount Blokade::Engine => "/blokade"
```

#### Roles

Blokade assumes that you are going to implement your own custom Role class in the application.
In doing so, the `Role` model must have the following database columns:

```ruby
# Role
Name (String)
Key (String, Index)
Blockadable ID (Integer, Index) (i.e. company_id)
```

In order to tie Blokade into your own implementation of the `Role` class you'll have to
invoke the following method:

```ruby
# Role
acts_as_blokade as: :role
```

#### Users

Blokade assumes that you are going to implement your own custom User class in the application.
In doing so, the `User` model must have the following database columns:

```ruby
# User
Blockadable ID (Integer, Index) (i.e. company_id)
Type (String, Index)
```

Blokade separates out the Frontend vs. Backend users by using Single Table Inheritance on
the User model. Frontend users are referred to as `luser` or local users. Backend users are
referred to as `skywire` or skywire administrators.

In order to tie Blokade into your own implementation of the `User` class you'll have to
invoke the following methods where appropriate:

```ruby
# app/models/luser.rb
acts_as_blokade as: :luser

# app/models/skywire.rb
acts_as_blokade as: :skywire
```

#### Blockadable

The Blockadable represents the model to which all the permissions will be scoped to. This could be something
like a company or a school. Blokade requires you to specify the thing which is `blockadable` so that it can
expect to look for that blockadable_id in the ability file. For example, if you wanted to limit a users permissions
to only apply to their own Company, then you would specify the following inside `company.rb`, to invoke Blokade:

```ruby
# company.rb
acts_as_blokade as: :blokade
```

In doing this, Blokade will then check to make sure that all the other models which invoke a call to `blokades frontend: [...]`
have the column `company_id`. It will then scope the permissions for that user to their own `company_id` which is associated
with their user account.


### Can-Can Ability

Since Blokade provides database backed permissions which tie into CanCan, we had to provide a way
to hook that functionality into an existing ability file. The way to do this is simple:

```ruby
# ability.rb

class MyAbility
  include Blokade::ActsAsAbility
end

class Ability < MyAbility
  include CanCan::Ability

  def initialize(user)
    # Load the permissions from Blokade
    super

    if user.admin?
      can :manage, :all
    end
  end
end
```

The call to `super` will load up all the permissions for that user from the database. Remember that
permissions in CanCan can be overridden at the bottom of the ability file. If you want to specify some
default permissions and THEN load the user permissions from the database, you would want to invoke the
call to `super` later on in the file.


### Blokades

Blokade provides a convenient method for specifying what default permissions should be specified for a
specific model. To enable this, you must first add the models class to Blokades `armada` directive. You
can do this via the Blokade initializer discussed above. Once that is complete, simply make a call to
the `blokades frontend: [...]` method and specify what permissions your model should roll out with. The following
values can be passed to the `blokades` method:

```ruby
:manage, :index, :show, :new, :create, :edit, :update, :destroy
```

If you want to have the standard actions listed above you can call the `blokades` method without specifying
any parameters, in this fashion:

```ruby
  blokades
```

Here is an example of how to invoke the `blokades` method with custom parameters:

```ruby
  blokades frontend: [:new, :create]
```

This will specify that only `:new` and `:create` actions should be provided by default. Note, a call to the
`blokades` method will only provide the default permissions for the FRONTEND. To have it generate the default
permissions in the backend, it must be specified as such:

```ruby
blokades backend: true
```

Note that the `backend` parameter can take either a boolean value or an array of the permissions which should
be created for that model in the backend.


#### Permission Restrictions

Blokade can be configured to restrict permissions for a user to a certain database backed column. To enable this,
simple pass the `restrict` parameter in the following fashion:

```ruby
blokades restrict: :assignable_id
```

If the permission instance stored in the database has `enable_restrictions` set to true, then the restrictions will apply.

### Default Roles and Permissions

Blokade has a directive for defining default roles and the permissions they should roll out with.

The following will invoke the fleets and schooners directives:

```ruby
# app/models/role.rb
class Role < ActiveRecord::Base
  schooner "Sales Representative",
    [
      {klass: Lead, blokades: [:manage], except: true, restrict: true, frontend: true},
      {klass: Company, blokades: [:show, :edit, :update], only: true, restrict: false, frontend: true}
    ]
  schooner "Sales Manager", [{klass: Company, blokades: [:show, :edit, :update], only: true, restrict: false, frontend: true}]
end
```

This will create two default roles: `Sales Representative` and `Sales Manager`. Blokade will parse the options you
pass into it and assign `schooner.permission_ids` to match the blokades you specify. This will allow you to write a
rake task to loop over all the Fleet using `Blokade.my_fleet` to iterate over them all.

An example is provided in the dummy application:

```ruby
def create_default_roles
  # Create the default schooners
  Blokade.my_fleet.schooners.each do |schooner|
    my_role = self.roles.find_or_create_by(name: schooner.role_name, key: schooner.role_name.parameterize, company: self)
    my_role.permission_ids = schooner.permission_ids
    my_role.save!
  end
end
```

### Rake Tasks

There are a couple of rake tasks for managing the Permissions stored in Blokade.

#### Frontend

* blokade:permissions:frontend:set_default

This will setup all the default frontend permissions specified by models which invoke `blokades frontend: [...]`

* blokade:permissions:frontend:fix_admin

This will fix all the frontend permissions for the Administrator role (assuming there is one)

* blokade:permissions:frontend:nuke

This will remove all the frontend permissions from the database.

#### Backend

* blokade:permissions:backend:set_default

This will setup all the default backend permissions specified by models which invoke `blokades backend: [...]`

* blokade:permissions:backend:nuke

This will remove all the backend permissions from the database.
