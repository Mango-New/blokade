module Blokade::Concerns::BlokadesOnConcerns
  extend ActiveSupport::Concern

  included do
    cattr_accessor :my_frontend_blokades
    cattr_accessor :my_backend_blokades
    cattr_accessor :force_i18n
    cattr_accessor :my_restrictions
  end

  module ClassMethods
    def set_blokades(params={})
      self.my_frontend_blokades = params.try(:[], :frontend)
      self.my_backend_blokades = params.try(:[], :backend)
    end

    def setup_i18n(force_i18n = false)
      self.force_i18n = force_i18n
    end

    def setup_restrictions(restrict)
      self.my_restrictions = restrict
    end

    def frontend_permissions
      result = {}
      self.my_frontend_blokades.each do |my_frontend_blokade|
        result[my_frontend_blokade] = {
          action: my_frontend_blokade.to_s,
          subject_class: self.name.to_s,
          description: blokade_description(my_frontend_blokade),
          backend: false,
          enable_restrictions: my_restrictions.present?,
        }
      end
      result
    end

    def backend_permissions
      result = {}
      self.my_backend_blokades.each do |my_backend_blokade|
        result[my_backend_blokade] = {
          action: my_backend_blokade.to_s,
          subject_class: self.name.to_s,
          description: blokade_description(my_backend_blokade),
          backend: true,
        }
      end
      result
    end

    def blokade_description(blokade)
      if self.force_i18n
        I18n.t(".activerecord.attributes.#{self.name.to_s.constantize.model_name.singular}.blokade.#{blokade.to_s}", default: I18n.t(".blokade.blokade.#{blokade.to_s}"))
      else
        blokadable_name = Blokade.blokadable_klass.model_name.singular
        case blokade
        when :manage
          "Grants all power to create, read, update, and remove #{self.model_name.human.pluralize.downcase} for the #{blokadable_name}."
        when :index
          "Permits viewing the index of all #{self.model_name.human.pluralize.downcase} for the #{blokadable_name}."
        when :show
          "Permits viewing a specific #{self.model_name.human.downcase} for the #{blokadable_name}."
        when :new
          "Permits viewing the new #{self.model_name.human.downcase} button and page for the #{blokadable_name}."
        when :create
          "Permits creating a new #{self.model_name.human.downcase} for the #{blokadable_name}."
        when :edit
          "Permits viewing the edit #{self.model_name.human.downcase} button and page for the #{blokadable_name}."
        when :update
          "Permits updating an existing #{self.model_name.human.downcase} for the #{blokadable_name}."
        when :destroy
          "Permits removing an existing #{self.model_name.human.downcase} from the #{blokadable_name}."
        else
          I18n.t(".activerecord.attributes.#{self.name.to_s.constantize.model_name.human.downcase}.blokade.#{blokade.to_s}", default: I18n.t(".blokade.blokade.#{blokade.to_s}"))
        end
      end
    end

  end
end
