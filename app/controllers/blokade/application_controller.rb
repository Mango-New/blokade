module Blokade
  if Blokade.use_parent_template
    class ApplicationController < ::ApplicationController
      helper BootstrapFlashHelper
      helper ParentLayoutHelper
      layout 'layouts/engine'
    end
  else
    # Use our normal layout
    class ApplicationController < ActionController::Base
      helper BootstrapFlashHelper
    end
  end
end
