ShowFor.setup do |config|
  config.show_for_tag = :dl

  config.wrapper_tag = nil

  config.label_tag = :dt

  config.content_tag = :dd

  config.separator = nil

  config.collection_tag = :ul

  config.association_methods = [ :name, :title, :to_s ]
end
