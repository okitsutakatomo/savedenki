class IndexController < ApplicationController

  def index
   @tweets = Tweet.popular.all(:limit => 10) 
  end

end
