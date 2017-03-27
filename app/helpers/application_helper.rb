module ApplicationHelper

  # metaタグ関連(http://easyramble.com/rails-meta-tags.html)
  def show_meta_tags
    if display_meta_tags.blank?
      assign_meta_tags
    end
    display_meta_tags
  end

  def assign_meta_tags(options = {})
    defaults = t('meta_tags.defaults')
    options.reverse_merge!(defaults)

    set_meta_tags(options)
  end

  # http://qiita.com/hisonl/items/05e7bca31475569f400d
  # def twitter_image_url
  #   url = image_url("tutorial/logo.png")
  #   url = "https:#{url}" if url =~ /\A\/\/s3/
  #   url
  # end
end
