class Role < ActiveRecord::Base

  acts_as_blokade as: :role
  blokades backend: true
  schooner "Sales Representative",
    [
      {klass: Lead, blokades: [:manage], except: true, restrict: true, frontend: true},
      {klass: Company, blokades: [:show, :edit, :update], only: true, restrict: false, frontend: true}
    ]
  schooner "Sales Manager", [{klass: Company, blokades: [:show, :edit, :update], only: true, restrict: false, frontend: true}]

end
