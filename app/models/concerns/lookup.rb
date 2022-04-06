module Lookup
  extend ActiveSupport::Concern

  included do
    scope :lookup, -> (id_or_slug) {
      if id_or_slug == 'all'
        all
      else
        friendly.find(id_or_slug)
      end
    }
  end
end
