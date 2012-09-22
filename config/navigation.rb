
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :home, 'Home', root_path

    primary.dom_class = 'nav'
  end
end
