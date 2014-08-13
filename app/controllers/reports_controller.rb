class ReportsController < ApplicationController

before_filter :authorize

# # using httparty gem to access Google Analytics (GA) API
# require 'httparty'

# # GA API 
# def get_reports
#   url = 'LINK HERE'
#   HTTParty.get(url)
# end






def time
    # defines 'time' for header comparitive dates
    time = Time.new
    @weekday = time.strftime("%A")
    @month = time.month
    @day = time.day
    @year = time.year

    @today_month = (time-(60 * 60 * 24 * 1)).month
    @today_day = (time-(60 * 60 * 24 * 1)).day
    @today_year = (time-(60 * 60 * 24 * 1)).year
   
    # WEEKLY DATES
    # real day minus 1 for data's sake
    @LW_month = (time-(60 * 60 * 24 * 7)).month
    @LW_day = (time-(60 * 60 * 24 * 7)).day
    @LW_year = (time-(60 * 60 * 24 * 7)).year

    @LW2_month = (time-(60 * 60 * 24 * 14)).month
    @LW2_day = (time-(60 * 60 * 24 * 14)).day
    @LW2_year = (time-(60 * 60 * 24 * 14)).year

    @LW3_month = (time-(60 * 60 * 24 * 8)).month
    @LW3_day = (time-(60 * 60 * 24 * 8)).day
    @LW3_year = (time-(60 * 60 * 24 * 8)).year


    # MONTHLY DATES
    # real day minus 1 for data's sake
    # Month to date
    @MTD_month = time.beginning_of_month.month
    @MTD_day = time.beginning_of_month.day
    @MTD_year = time.beginning_of_month.year

    @MTD2_month = (time-(60 * 60 * 24 * 366)).beginning_of_month.month
    @MTD2_day = (time-(60 * 60 * 24 * 366)).beginning_of_month.day
    @MTD2_year = (time-(60 * 60 * 24 * 366)).beginning_of_month.year

    @MTD3_month = (time-(60 * 60 * 24 * 366)).month
    @MTD3_day = (time-(60 * 60 * 24 * 366)).day
    @MTD3_year = (time-(60 * 60 * 24 * 366)).year

    # Month over month
    @LM_month = (time-(60 * 60 * 24 * 30)).month
    @LM_day = (time-(60 * 60 * 24 * 30)).day
    @LM_year = (time-(60 * 60 * 24 * 30)).year

    @LM2_month = (time-(60 * 60 * 24 * 60)).month
    @LM2_day = (time-(60 * 60 * 24 * 60)).day
    @LM2_year = (time-(60 * 60 * 24 * 60)).year

    @LM3_month = (time-(60 * 60 * 24 * 31)).month
    @LM3_day = (time-(60 * 60 * 24 * 31)).day
    @LM3_year = (time-(60 * 60 * 24 * 31)).year

    # YEARY DATES
    # real day minus 1 for data's sake
    # Year to date
    @YTD_month = time.beginning_of_year.month
    @YTD_day = time.beginning_of_year.day
    @YTD_year = time.beginning_of_year.year

    @YTD2_month = (time-(60 * 60 * 24 * 366)).beginning_of_year.month
    @YTD2_day = (time-(60 * 60 * 24 * 366)).beginning_of_year.day
    @YTD2_year = (time-(60 * 60 * 24 * 366)).beginning_of_year.year

    @YTD3_month = (time-(60 * 60 * 24 * 366)).month
    @YTD3_day = (time-(60 * 60 * 24 * 366)).day
    @YTD3_year = (time-(60 * 60 * 24 * 366)).year

    # Year over year
    @LY_month = (time-(60 * 60 * 24 * 365)).month
    @LY_day = (time-(60 * 60 * 24 * 365)).day
    @LY_year = (time-(60 * 60 * 24 * 365)).year

    @LY2_month = (time-(60 * 60 * 24 * 730)).month
    @LY2_day = (time-(60 * 60 * 24 * 730)).day
    @LY2_year = (time-(60 * 60 * 24 * 730)).year

    @LY3_month = (time-(60 * 60 * 24 * 366)).month
    @LY3_day = (time-(60 * 60 * 24 * 366)).day
    @LY3_year = (time-(60 * 60 * 24 * 366)).year

end

  def report
    time
  end

  def weekly
    time
  end

  def monthly  
    time
  end

  def yearly
    time
  end

end