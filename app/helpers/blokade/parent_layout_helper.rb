module Blokade
  module ParentLayoutHelper
    if Blokade.use_parent_template
      # Any links should be forwarded back up to the parent application
      def method_missing(method, *args, &block)
        if (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
          main_app.send(method, *args)
        else
          super
        end
      end
    end
  end
end
