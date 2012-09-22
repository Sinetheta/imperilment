ShowFor.setup do |config|
  config.show_for_tag = :dl

  config.wrapper_tag = nil

  config.label_tag = :dt
  config.label_class = nil

  config.content_tag = :dd
  config.content_class = nil

  config.separator = nil

  config.collection_tag = :ul

  config.association_methods = [ :name, :title, :to_s ]
end
