class Role < ActiveRecord::Base

  schooner "Sales Representative",
    [
      {klass: Lead, barriers: [:manage], except: true, restrict: true, convoy: :frontend},
      {klass: Company, barriers: [:show, :edit, :update], only: true, restrict: false, convoy: :frontend}
    ]
  schooner "Sales Manager", [{klass: Company, barriers: [:show, :edit, :update], only: true, restrict: false, convoy: :frontend}]

end
