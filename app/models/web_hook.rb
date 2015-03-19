require 'uri'

class WebHook < ActiveRecord::Base
  validates :url, presence: true, url: true

  def uri
    URI.parse(url)
  end
end
