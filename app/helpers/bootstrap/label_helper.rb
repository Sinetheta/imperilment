module Bootstrap::LabelHelper
  # Renders a Bootstrap label.
  #
  # @param text [String] the text rendered in the label
  # @param class [String, Symbol] the bootstrap label type
  # @param options [Hash] a hash of options. Passed straight through to the
  #        underlying "span" tag.
  #
  def bs_label (text, style = :default, options = {})
    options = options.dup

    options[:class] ||= "label"
    options[:class] << " label-#{style}"

    content_tag :span, text, options
  end
end
