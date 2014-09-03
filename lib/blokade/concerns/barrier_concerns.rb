module Blokade
  module Concerns
    module BarrierConcerns
      extend ActiveSupport::Concern

      included do
        cattr_accessor :my_harbor_keys
      end

      module ClassMethods
        def set_harbor_keys(harbor_keys = [])
          self.my_harbor_keys = harbor_keys
          setup_dynamic_convoys
          setup_dynamic_blokades
          setup_dynamic_restrictions
        end

        def my_harbors
          Blokade.harbor.harbors.try(:[], self)
        end

        def setup_dynamic_convoys
          self.my_harbor_keys.each do |harbor_key|
            send(:define_singleton_method, "#{harbor_key}_permissions".to_sym) do
              if my_harbors.present?
                result = {}
                my_barrier = my_harbors[harbor_key]
                my_harbors[harbor_key].my_barriers.each do |this_barrier|
                  result[this_barrier] = {
                    action: this_barrier.to_s,
                    subject_class: my_barrier.my_klass,
                    description: barrier_description(my_barrier, this_barrier),
                    backend: (my_barrier.my_convoy == :backend),
                    enable_restrictions: my_barrier.my_restrictions.present?,
                  }
                end
                result
              else
                # Nothing was found
                {}
              end
            end
          end
        end

        def setup_dynamic_blokades
          self.my_harbor_keys.each do |harbor_key|
            send(:define_singleton_method, "my_#{harbor_key}_blokades".to_sym) do
              my_harbors.try(:[], harbor_key).try(:my_barriers)
            end
          end
        end

        def setup_dynamic_restrictions
          self.my_harbor_keys.each do |harbor_key|
            send(:define_singleton_method, "my_#{harbor_key}_restrictions".to_sym) do
              my_harbors.try(:[], harbor_key).try(:my_restrictions)
            end
          end
        end

        def barrier_description(my_barrier, barrier)
          if my_barrier.my_i18n
            I18n.t(".activerecord.attributes.#{self.name.to_s.constantize.model_name.singular}.blokade.#{barrier.to_s}", default: I18n.t(".blokade.blokade.#{barrier.to_s}"))
          else
            blokadable_name = Blokade.blokadable_klass.model_name.singular
            case barrier
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
              I18n.t(".activerecord.attributes.#{self.name.to_s.constantize.model_name.human.downcase}.blokade.#{barrier.to_s}", default: I18n.t(".blokade.blokade.#{barrier.to_s}"))
            end
          end
        end

      end
    end
  end
end
