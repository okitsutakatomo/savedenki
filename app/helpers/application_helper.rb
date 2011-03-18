# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TwitterText::Autolink

  def template_error_messages_for (object_name, options = {})
    options = options.symbolize_keys
    object = instance_variable_get("@#{object_name}")
    return nil unless object
    unless object.errors.empty?
      render :partial=>"commons/error_messages_for",
        :locals=>{:messages=>object.errors.full_messages, :object=>object}
    end
  end


  #see: http://rememo.seesaa.net/article/132845355.html
  def mobile_ga_url
    return url_for(:controller => :ga, :action => :ga,
                   :utmac => "MO-22136817-1",
                   :utmn => rand(100000*100000),
                   :utmr => URI.escape(request.referer.blank? ? '-' : request.referer),
                   :utmp => URI.escape(request.request_uri),
                   :guid => 'ON'
                  )
  end

  def mobile_ga_tag
    if ENV['RAILS_ENV'] != 'test' 
      return '<img src="' + mobile_ga_url + '" alt="" width="1" height="1" />'
    end
  end

  def encode_message(message)
    return message if message.blank?
    message = message.gsub(/@([a-zA-Z0-9_]+)/, '@<a target="_blank" href="http://twitter.com/\1">\1</a>')
    message = message.gsub(/#([a-zA-Z0-9_]+)/, '<a target="_blank" href="http://twitter.com/search?q=%23\1">#\1</a>')
    return message
  end

  def encode_message_for_tweet(message)
    return message if message.blank?
    message = message.gsub("http://mimiuchi.com", "")
    return message
  end

  def has_new_onewayinfo?(user)
    return false if user.blank?
    user.has_new_oneway? ? true : false
  end

  def has_new_coupleinfo?(user)
    return false if user.blank?
    user.has_new_couple? ? true : false
  end

end
