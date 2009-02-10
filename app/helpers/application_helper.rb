# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def reqd
    '<span class="reqd">*</span>'
  end

  def tip(text)
    "<span class='tip'>#{text}</span>"
  end

  def cancel_link(url, label = 'Cancel')
    link_to label, url, :class => 'cancel_link', :confirm => 'Cancel operation?'
  end

  def flash_message(type = :notice)
    "<div class='flash_message'><div class='curved #{type}'>
      <a href='#' onclick='return disable_flash_messages();'>&times;#{javascript_tag('setTimeout("disable_flash_messages()", 5000)')}</a>
      #{flash[type]}</div>
      </div>" if flash[type]
  end

end
