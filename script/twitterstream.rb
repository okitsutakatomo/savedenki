#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../config/environment"

@env = "development"

if ARGV[1]
  @env = ARGV[1]
end

case ARGV[0]
when "start"
  fork do
      system "ruby #{RAILS_ROOT}/script/runner -e #{@env} 'TwitterStreamUtil::StreamApiWorker.execute'"
  end
when "stop"
  command = "ps aux | grep ruby"
  
  IO.popen(command) do |pipe|
    pipe.each("\n") do |line|
      #okitsu   26276   2.2  1.2  2481488  48752 s002  S+   10:44PM   0:05.23 ruby script/runner TwitterStreamUtil::StreamApiWorker.execute
      if line.include?("TwitterStreamUtil::StreamApiWorker.execute")
        pid = line.split(' ')[1]
        cmd = "kill -9 #{pid}"
        begin
          system cmd
        rescue Exception => e
          #例外が出るけど無視する
        end
      end
    end
  end  
else
    p "option:"
    p " start: start StreamApiWorker daemon"   
    p " stop: start StreamApiWorker daemon"       
end


