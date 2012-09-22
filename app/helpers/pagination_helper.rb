module PaginationHelper
  def paginate records, options={}
    paginate_info(records, options) + will_paginate(records, options)
  end
  def paginate_info records, options={}
    content_tag(:div, page_entries_info(records, options), class: 'pagination-info pagination-centered')
  end
  def will_paginate records, options={}
    options = {
      renderer: BootstrapPagination::Rails,
      class: 'pagination pagination-centered'
    }.merge(options)
    super(records, options)
  end
end
