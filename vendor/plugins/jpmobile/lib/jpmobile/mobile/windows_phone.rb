# -*- coding: utf-8 -*-
# =WindowsPhone

module Jpmobile::Mobile
  # ==WindowsPhone
  class WindowsPhone < AbstractMobile
    # 蟇ｾ蠢懊☆繧偽ser-Agent縺ｮ豁｣隕剰｡ｨ迴ｾ
    USER_AGENT_REGEXP = /Windows Phone/

    # 無効化
    def valid_ip?
      false
    end

    # cookie は有効と見なす
    def supports_cookie?
      true
    end

    # smartphone なので true
    def smart_phone?
      true
    end

  end
end

