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
end
