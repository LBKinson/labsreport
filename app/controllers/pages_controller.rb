class PagesController < ApplicationController

def time
    # defines 'time' for header comparitive dates
    time = Time.new
    @weekday = time.strftime("%A")
    @today = time.strftime('%m/%d/%y')
end

  def home
  	time
  end

end