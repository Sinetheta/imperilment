module TitleHelper
  def title title=nil
    @title ||= []
    @title << title if title
    @title
  end
end
