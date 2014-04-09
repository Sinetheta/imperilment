# Encoding: utf-8

module BootstrapHelper
  def icon *classes
    classes = classes.map {|x| "fa-#{x}" } << 'fa'
    content_tag(:i, '', class: classes) + ' '
  end
  def flash_notice type, css_class
    return unless flash[type].present?
    content_tag(:div, class: "alert alert-block alert-#{css_class} fade in") do
      button_tag("×", type: 'button', class: 'close', data: {dismiss: 'alert'}) +
      content_tag(:h4, t(type, scope: 'flash.header'), class: 'alert-heading') +
      content_tag(:p, flash[type])
    end
  end
  def progress_bar percentage, &block
    block ||= proc{}
    content_tag(:div, content_tag(:div, class: 'bar', style: ("width: %.2f%%" % percentage), &block), class: 'progress progress-success')
  end
end
