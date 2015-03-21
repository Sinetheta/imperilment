require 'uri'

class WebHook < ActiveRecord::Base
  validates :url, presence: true, url: true
  scope :active, -> { where(active: true) }

  def uri
    URI.parse(url)
  end
end
