
module BreadcrumbHelper
  def breadcrumb content=nil, &block
    @breadcrumbs ||= []
    if content
      @breadcrumbs << content
    elsif block_given?
      @breadcrumbs << capture(&block).strip.html_safe
    end
    @breadcrumbs
  end
  def render_breadcrumbs divider='/'
    return if breadcrumb.empty?
    breadcrumbs = breadcrumb.dup
    last = breadcrumbs.shift
    divider = content_tag(:span, divider, class: :divider)
    content = breadcrumbs.reverse.map do |link|
      content_tag(:li) do
        h(link) + divider
      end
    end.join.html_safe
    content << content_tag(:li, h(last))
    content_tag(:ul, content, class: 'breadcrumb')
  end
end
