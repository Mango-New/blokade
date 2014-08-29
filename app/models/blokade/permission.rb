module Blokade
  class Permission < ActiveRecord::Base
    acts_as_blokade as: :permission
  end
end
