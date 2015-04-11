# Encoding: utf-8

module BootstrapHelper
  def icon(name)
    %(<i class="icon-#{name}"></i> ).html_safe
  end

  def flash_notice(type, css_class)
    return unless flash[type].present?
    content_tag(:div, class: "alert alert-block alert-#{css_class} fade in") do
      button_tag("×", type: 'button', class: 'close', data: { dismiss: 'alert' }) +
        content_tag(:h4, t(type, scope: 'flash.header'), class: 'alert-heading') +
        content_tag(:p, flash[type])
    end
  end
end
