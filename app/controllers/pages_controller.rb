class PagesController < ApplicationController

def time
    # defines 'time' for header comparitive dates
    time = Time.new
    @weekday = time.strftime("%A")
    @header_today = time.strftime('%Y-%m-%d')
end

  def home
  	time
  end

end