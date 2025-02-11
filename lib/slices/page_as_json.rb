module Slices
  # We keep this method in here to facilate easier overriding when re-opening Page.
  module PageAsJSON
    include Slices::LocalizedFields

    def as_json(options = {})
      options ||= {}

      hash = attributes.symbolize_keys.except(:_id, :_type, :_keywords, :author_id, :set_slices).merge(
        id:        id.to_s,
        permalink: permalink,
        slices:    ordered_slices_for(options[:slice_embed]).map {|slice| slice.as_json },
        available_layouts: available_layouts
      )

      if author
        hash[:author] = { id: author.id.to_s, name: author.name }
      end
      localized_field_names.each do |name|
        hash.merge!(name => send(name))
      end

      keys = options[:only]
      keys ? hash.slice(keys) : hash
    end
  end
end
