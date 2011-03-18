RETRY_COUNT = 5
RETRY_SECONDS = 1
WAIT_SECONDS = 30

USERNAME = "save_denki"
PASSWORD = "save_denki123"
KEYWORD = ["#save_denki", "#jishin"]

module TwitterStreamUtil
  class StreamApiWorker
    def self.execute(args = nil)
      RAILS_DEFAULT_LOGGER.info "################ START StreamApiWorker ####################"
      filter = TwitterStreamUtil::Filter.new(RETRY_COUNT, RETRY_SECONDS, WAIT_SECONDS, USERNAME, PASSWORD, KEYWORD)
      filter.main
      RAILS_DEFAULT_LOGGER.info "################ END StreamApiWorker ####################"
    end
  end
end

