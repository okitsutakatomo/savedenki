#携帯サイト向けgoogle analytics対応
#
#see: http://rememo.seesaa.net/article/132845355.html
require 'net/http'
Net::HTTP.version_1_2
class GaController < ApplicationController

  G_COOKIE_NAME = :__utmmobile
  GIF_DATA = "GIF89a\001\000\001\000\200\000\000\377\377\377\377\377\377!\371\004\001\n\000\001\000,\000\000\000\000\001\000\001\000\000\002\002L\001\000;"
  def ga
    document_referer = params[:utmr].blank? ?
      '-' : ERB::Util.u(delete_trans_sid(params[:utmr]))
    document_path = params[:utmp].blank? ?
      '' : ERB::Util.u(delete_trans_sid(params[:utmp]))

    account = params[:utmac]
    user_agent = request.user_agent.blank? ?
      '' : request.user_agent.to_s

    remote_address = request.remote_addr
    if remote_address.blank?
      remote_address = ''
    elsif remote_address =~ /^([^.]+\.[^.]+\.[^.]+\.).*/
      remote_address = "#{$1}0"
    else
      remote_address = ''
    end

    visitor_id = cookies[G_COOKIE_NAME]

    if visitor_id.blank?
      guid = (request.mobile && request.mobile.ident) ?
        request.mobile.ident : ''

      message = ''
      if guid.blank?
        message = "#{user_agent}#{Digest::SHA1.hexdigest(rand.to_s)}#{Time.now.to_i}"
      else
        message = "#{guid}#{account}"
      end

      md5string = Digest::MD5.hexdigest(message)

      visitor_id = "0x#{md5string[0,16]}"
    end
    cookies[G_COOKIE_NAME] = {
      :value => visitor_id,
      :expires => 20.years.ago,
      :path => "/",
      :domain => "mimiuchi.com"
    }
    utm_gif_location = "http://www.google-analytics.com/__utm.gif";

    queries = []
    queries << "utmwv=4.4sh"
    queries << "utmn=#{rand(1000000*1000000)}"
    queries << "utmhn=#{ERB::Util.u("mimiuchi.com")}"
    queries << "utmr=#{ERB::Util.u(document_referer)}"
    queries << "utmp=#{ERB::Util.u(document_path)}"
    queries << "utmac=#{account}"
    queries << "utmcc=__utma%3D999.999.999.999.999.1%3B"
    queries << "utmvid=#{visitor_id}"
    queries << "utmip=#{remote_address}"

    uri = URI.parse(utm_gif_location + '?' + queries.join('&'))

    unless ENV['RAILS_ENV'] == 'test'
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.get(uri.request_uri, {
          "user_agent" => request.user_agent.to_s,
          "Accepts-Language" => request.accept_language.to_s
        })
      end
      logger.error "-----Send Request To Google Analytics-----"
      logger.error uri.to_s
      logger.error "------------------------------------------"
    end

    headers["X-GA-MOBILE-URL"] = uri.to_s unless params[:utmdebug].blank?
    headers["Cache-Control"] = "private, no-cache, no-cache=Set-Cookie, proxy-revalidate"
    headers["Pragma"] = "no-cache"
    headers["Expires"] = "Wed, 17 Sep 1975 21:32:10 GMT"

    send_data GIF_DATA, :type => "image/gif", :disposition => "inline"
  end

  private
  def delete_trans_sid(str)
    if session_key.blank?
      return str.to_s
    else
      return str.to_s.gsub(/#{session_key}=[^&]*&?/, '')
    end
  end

end

