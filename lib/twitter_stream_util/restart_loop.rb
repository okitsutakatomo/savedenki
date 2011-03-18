module TwitterStreamUtil
  class RestartLoop
    def initialize(retry_count, retry_seconds, wait_seconds)
      @retry_count = retry_count
      @retry_seconds = retry_seconds
      @wait_seconds = wait_seconds
    end

    def success_restart()
      @fail_count = 0
      @start_ts = nil
      @ex = nil
    end

    def restart?()
      @fail_count > 0
    end

    def make_error_msg()
      "#{@start_ts.to_s} -> #{Time.now.to_s} : #{@ex.to_s}"
    end

    def main()
      while true
        @fail_count = 0
        @start_ts = nil
        @ex = nil
        while true
          begin
            execute()
          rescue => e
            if 0 == @fail_count
              @start_ts = Time.now
              @ex = e
            end
            if @fail_count >= @retry_count
              fail_restart()
              break
            end
            @fail_count += 1
            sleep(@retry_seconds)
          end
        end
        sleep(@wait_seconds)
      end
    end
  end
end

