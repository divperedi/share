module ApplicationHelper
  def form_field_with_errors(object, field, &block)
    if object.errors[field].any?
      content_tag :div, class: "field_with_errors" do
        concat capture(&block)
        concat content_tag(:div, object.errors[field].first, class: "error-message")
      end
    else
      capture(&block)
    end
  end
end
