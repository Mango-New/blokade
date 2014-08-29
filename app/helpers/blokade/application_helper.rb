module Blokade
  module ApplicationHelper
    def title(page_title, show_sub_title = true, options={})
      content_for(:title) { page_title }
      if show_sub_title
        sub_title(page_title)
      end
    end

    def sub_title(sub_title, options={})
      content_for(:sub_title) { sub_title }
    end
  end
end
