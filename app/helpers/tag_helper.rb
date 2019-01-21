module TagHelper
  def display_tags(tags, current_tag)
    tags.map do |tag|
      unless current_tag == tag
        content_tag(:tr) do
          display_individual_tag(tag)
        end
      end
    end.join.html_safe
  end

  def display_individual_tag(tag)
    items = [
      tag.category,
      link_to('Edit', dashboard_index_path(tag_id: tag)),
      link_to('Delete', admin_tag_path(tag), method: :delete, data: { confirm: 'Are you sure?' })
    ]
    items.map { |item| content_tag(:td, item) }.join.html_safe
  end
end