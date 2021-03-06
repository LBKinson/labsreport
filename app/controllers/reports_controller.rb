class ReportsController < ApplicationController

# commented out for dev, MUST COMMENT BACK IN FOR PRODUCTION
before_filter :authorize

# GA API access     AIzaSyATHWpIVojI9ii_cHy9kdL2fbogEeghY7o
def visitor 
  @SERVICE_ACCOUNT_EMAIL_ADDRESS = '154515577302-e7esj1h0cnnrmulevvujumjv1m3hjk9c@developer.gserviceaccount.com' # looks like 12345@developer.gserviceaccount.com
  @PATH_TO_KEY_FILE              = "#{Rails.root}/app/controllers/ON_Dashboard-66376614.p12"
  @PROFILE                       = 'ga:66376614' # your GA profile id, looks like 'ga:12345'


  # @SERVICE_ACCOUNT_EMAIL_ADDRESS = ENV['GA_SERVICE_ACCOUNT_EMAIL_ADDRESS']
  # @PATH_TO_KEY_FILE              = "#{Rails.root}/app/controllers/GA_Dashboard-1f3726b11932.p12"
  # @PROFILE                       = ENV['GA_PROFILE']

  require 'json'
  require 'google/api_client'

  # set up a client instance
  @client  = Google::APIClient.new

  @client.authorization = Signet::OAuth2::Client.new(
    :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
    :audience             => 'https://accounts.google.com/o/oauth2/token',
    :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
    :issuer               => @SERVICE_ACCOUNT_EMAIL_ADDRESS,
    :signing_key          => Google::APIClient::PKCS12.load_key(@PATH_TO_KEY_FILE, 'notasecret')
  ).tap { |auth| auth.fetch_access_token! }

  @api_method = @client.discovered_api('analytics','v3').data.ga.get

end


def time
    # defines 'time' for header comparitive dates
    time = Time.new
    @weekday = time.strftime("%A")
    @header_today = time.strftime('%Y-%m-%d')
    
    # real day minus 1 for data's sake
    @today = (time-(60 * 60 * 24 * 1)).strftime('%Y-%m-%d')
   
    # WEEKLY DATES
    # real day minus 1 for data's sake
    @LW = (time-(60 * 60 * 24 * 7)).strftime('%Y-%m-%d')
    @LW2 = (time-(60 * 60 * 24 * 14)).strftime('%Y-%m-%d')
    @LW3 = (time-(60 * 60 * 24 * 8)).strftime('%Y-%m-%d')


    # MONTHLY DATES
    # real day minus 1 for data's sake
    # Month to date
    @MTD = time.beginning_of_month.strftime('%Y-%m-%d')
    @MTD2 = (time-(60 * 60 * 24 * 366)).beginning_of_month.strftime('%Y-%m-%d')
    @MTD3 = (time-(60 * 60 * 24 * 366)).strftime('%Y-%m-%d')

    # Month over month
    @LM = (time-(60 * 60 * 24 * 30)).strftime('%Y-%m-%d')
    @LM2 = (time-(60 * 60 * 24 * 60)).strftime('%Y-%m-%d')
    @LM3 = (time-(60 * 60 * 24 * 31)).strftime('%Y-%m-%d')


    # YEARLY DATES
    # real day minus 1 for data's sake
    # Year to date
    @YTD = time.beginning_of_year.strftime('%Y-%m-%d')
    @YTD2 = (time-(60 * 60 * 24 * 366)).beginning_of_year.strftime('%Y-%m-%d')
    @YTD3 = (time-(60 * 60 * 24 * 366)).strftime('%Y-%m-%d')

    # Year over year
    @LY = (time-(60 * 60 * 24 * 365)).strftime('%Y-%m-%d')
    @LY2 = (time-(60 * 60 * 24 * 730)).strftime('%Y-%m-%d')
    @LY3 = (time-(60 * 60 * 24 * 366)).strftime('%Y-%m-%d')


    date_select("report_date", "selected_date", start_year: 2012, use_month_numbers: true, )

end


  def report
    time
  end

  def weekly
    time
    visitor

    # fucking around
    result = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW,
    'end-date'   => @today,
    'dimensions' => 'ga:source',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
    # 'sort'       => '-ga:sessions'
    # 'filters'    => 'ga:pagePath==/url/to/user'
 }).data

    
@generic_result = result.inspect




    # this year visits, uniques, pageviews, ppvs, bounce, visit duration
    this_year_result = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
    # 'filters'    => 'ga:pagePath==/url/to/user'
 }).data.totals_for_all_results

    @generic_result2 = this_year_result.inspect


    # this year 'galleries'
    photoViewsGalleries = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # this year 'artists'
    photoViewsArtists = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this year 'first-look'
    photoViewsFirstLook = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results

    # this year data variables
    @tyVisits = this_year_result['ga:sessions'].to_f.round
    @tyUniqueVisitors = this_year_result['ga:users'].to_f.round
    @tyPageviews = this_year_result['ga:pageviews'].to_f.round
    @tyPhotoViews = photoViewsGalleries['ga:pageviews'].to_f.round + photoViewsArtists['ga:pageviews'].to_f.round + photoViewsFirstLook['ga:pageviews'].to_f.round
    @tyPPV = this_year_result['ga:pageviewsPerSession'].to_f.round(2)
    @tyBounce = this_year_result['ga:bounceRate'].to_f.round(2)
    @avgTYVisitDuration = Time.at(this_year_result['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgTYVD = @avgTYVisitDuration.to_f


  # binding.pry

    #last year visits, uniques, pageviews, ppvs, bounce, visit duration
    last_year_result = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW2,
    'end-date'   => @LW3,
    'dimensions' => 'ga:source',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
  }).data.totals_for_all_results

    # last year 'galleries'
    lyphotoViewsGalleries = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW2,
    'end-date'   => @LW3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # last year 'artists'
    lyphotoViewsArtists = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW2,
    'end-date'   => @LW3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # last year 'first-look'
    lyphotoViewsFirstLook = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LW2,
    'end-date'   => @LW3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results

    # last year data variables
    @lyVisits = last_year_result['ga:sessions'].to_f.round
    @lyUniqueVisitors = last_year_result['ga:users'].to_f.round
    @lyPageviews = last_year_result['ga:pageviews'].to_f.round
    @lyPhotoViews = lyphotoViewsGalleries['ga:pageviews'].to_f.round + lyphotoViewsArtists['ga:pageviews'].to_f.round + lyphotoViewsFirstLook['ga:pageviews'].to_f.round
    @lyPPV = last_year_result['ga:pageviewsPerSession'].to_f.round(2)
    @lyBounce = last_year_result['ga:bounceRate'].to_f.round(2)
    @avgLYVisitDuration = Time.at(last_year_result['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgLYVD = @avgLYVisitDuration.to_f

    # binding.pry

    # row color logic
    # if TY > LY @row_color = "success"
    # if TY < LY @row_color = "warning"
    # if TY == LY @row_color = "active"

    if @tyVisits > @lyVisits
      @TYrow_color = "success"
    elsif @tyVisits < @lyVisits
      @TYrow_color = "danger"
    else 
      @TYrow_color = "active"
    end

    if @tyUniqueVisitors > @lyUniqueVisitors
      @UVrow_color = "success"
    elsif @tyUniqueVisitors < @lyUniqueVisitors
      @UVrow_color = "danger"
    else 
      @UVrow_color = "active"
    end
      
    if @tyPageviews > @lyPageviews
      @PVrow_color = "success"
    elsif @tyPageviews < @lyPageviews
      @PVrow_color = "danger"
    else 
      @PVrow_color = "active"
    end
    
    if @tyPhotoViews > @lyPhotoViews
      @PHrow_color = "success"
    elsif @tyPhotoViews < @lyPhotoViews
      @PHrow_color = "danger"
    else 
      @PHrow_color = "active"
    end

    if @tyPPV > @lyPPV
      @PPVrow_color = "success"
    elsif @tyPPV < @lyPPV
      @PPVrow_color = "danger"
    else 
      @PPVrow_color = "active"
    end

    if @tyBounce < @lyBounce
      @Brow_color = "success"
    elsif @tyBounce > @lyBounce
      @Brow_color = "danger"
    else 
      @Brow_color = "active"
    end

    if @avgTYVisitDuration > @avgLYVisitDuration
      @VDrow_color = "success"
    elsif @avgTYVisitDuration < @avgLYVisitDuration
      @VDrow_color = "danger"
    else 
      @VDrow_color = "active"
    end

  end

  def monthly  
    time
    visitor

    # MONTH OVER MONTH
    #
    # this year visits, uniques, pageviews, PPVs, bounce, TOS
    this_year_result2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LM,
    'end-date'   => @today,
    'dimensions' => 'ga:pagepath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
    # 'filters'    => 'ga:pagePath==/url/to/user'
 }).data.totals_for_all_results

    # this month 'galleries'
    photoViewsGalleries2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LM,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # this month 'artists'
    photoViewsArtists2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LM,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this month 'first-look'
    photoViewsFirstLook2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LM,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results


    # this year data variables
    @tyVisits2 = this_year_result2['ga:sessions'].to_f.round
    @tyUniqueVisitors2 = this_year_result2['ga:users'].to_f.round
    @tyPageviews2 = this_year_result2['ga:pageviews'].to_f.round
    @tyPhotoViews2 = photoViewsGalleries2['ga:pageviews'].to_f.round + photoViewsArtists2['ga:pageviews'].to_f.round + photoViewsFirstLook2['ga:pageviews'].to_f.round
    @tyPPV2 = this_year_result2['ga:pageviewsPerSession'].to_f.round(2)
    @tyBounce2 = this_year_result2['ga:bounceRate'].to_f.round(2)
    @avgTYVisitDuration2 = Time.at(this_year_result2['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgTYVD2 = this_year_result2['ga:avgSessionDuration'].to_f


   # binding.pry

    #last year
    last_year_result2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LM2,
    'end-date'   => @LM3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
  }).data.totals_for_all_results

    # this month 'galleries'
    photoViewsGalleries2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LM2,
    'end-date'   => @LM3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # this month 'artists'
    photoViewsArtists2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LM2,
    'end-date'   => @LM3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this month 'first-look'
    photoViewsFirstLook2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LM2,
    'end-date'   => @LM3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results

    # last year data variables
    @lyVisits2 = last_year_result2['ga:sessions'].to_f.round
    @lyUniqueVisitors2 = last_year_result2['ga:users'].to_f.round
    @lyPageviews2 = last_year_result2['ga:pageviews'].to_f.round
    @lyPhotoViews2 = photoViewsGalleries2['ga:pageviews'].to_f.round + photoViewsArtists2['ga:pageviews'].to_f.round + photoViewsFirstLook2['ga:pageviews'].to_f.round
    @lyPPV2 = last_year_result2['ga:pageviewsPerSession'].to_f.round(2)
    @lyBounce2 = last_year_result2['ga:bounceRate'].to_f.round(2)
    @avgLYVisitDuration2 = Time.at(last_year_result2['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgLYVD2 = last_year_result2['ga:avgSessionDuration'].to_f

    # binding.pry

    # row color logic
    # if TY > LY @row_color = "success"
    # if TY < LY @row_color = "warning"
    # if TY == LY @row_color = "active"
    if @tyVisits2 > @lyVisits2
      @TYrow_color2 = "success"
    elsif @tyVisits2 < @lyVisits2
      @TYrow_color2 = "danger"
    else 
      @TYrow_color2 = "active"
    end

    if @tyUniqueVisitors2 > @lyUniqueVisitors2
      @UVrow_color2 = "success"
    elsif @tyUniqueVisitors2 < @lyUniqueVisitors2
      @UVrow_color2 = "danger"
    else 
      @UVrow_color2 = "active"
    end
      
    if @tyPageviews2 > @lyPageviews2
      @PVrow_color2 = "success"
    elsif @tyPageviews2 < @lyPageviews2
      @PVrow_color2 = "danger"
    else 
      @PVrow_color2 = "active"
    end

    if @tyPhotoViews2 > @lyPhotoViews2
      @PHrow_color2 = "success"
    elsif @tyPhotoViews2 < @lyPhotoViews2
      @PHrow_color2 = "danger"
    else 
      @PHrow_color2 = "active"
    end

    if @tyPPV2 > @lyPPV2
      @PPVrow_color2 = "success"
    elsif @tyPPV2 < @lyPPV2
      @PPVrow_color2 = "danger"
    else 
      @PPVrow_color2 = "active"
    end

    if @tyBounce2 < @lyBounce2
      @Brow_color2 = "success"
    elsif @tyBounce2 > @lyBounce2
      @Brow_color2 = "danger"
    else 
      @Brow_color2 = "active"
    end

    if @avgTYVisitDuration2 > @avgLYVisitDuration2
      @VDrow_color2 = "success"
    elsif @avgTYVisitDuration2 < @avgLYVisitDuration2
      @VDrow_color2 = "danger"
    else 
      @VDrow_color2 = "active"
    end


    # MONTH TO DATE
    #
    # this year pageviews
    this_year_result = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @MTD,
    'end-date'   => @today,
    'dimensions' => 'ga:pagepath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
    # 'filters'    => 'ga:pagePath==/url/to/user'
 }).data.totals_for_all_results

    # this year 'galleries'
    photoViewsGalleries = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @MTD,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # this year 'artists'
    photoViewsArtists = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @MTD,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this year 'first-look'
    photoViewsFirstLook = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @MTD,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results

    # this year data variables
    @tyVisits = this_year_result['ga:sessions'].to_f.round
    @tyUniqueVisitors = this_year_result['ga:users'].to_f.round
    @tyPageviews = this_year_result['ga:pageviews'].to_f.round
    @tyPhotoViews = photoViewsGalleries['ga:pageviews'].to_f.round + photoViewsArtists['ga:pageviews'].to_f.round + photoViewsFirstLook['ga:pageviews'].to_f.round
    @tyPPV = this_year_result['ga:pageviewsPerSession'].to_f.round(2)
    @tyBounce = this_year_result['ga:bounceRate'].to_f.round(2)
    @avgTYVisitDuration = Time.at(this_year_result['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgTYVD = this_year_result['ga:avgSessionDuration'].to_f


   # binding.pry

    #last year
    last_year_result = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @MTD2,
    'end-date'   => @MTD3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
  }).data.totals_for_all_results

    # last year 'galleries'
    lyphotoViewsGalleries = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @MTD2,
    'end-date'   => @MTD3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # last year 'artists'
    lyphotoViewsArtists = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @MTD2,
    'end-date'   => @MTD3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this year 'first-look'
    lyphotoViewsFirstLook = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @MTD2,
    'end-date'   => @MTD3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results

    # last year data variables
    @lyVisits = last_year_result['ga:sessions'].to_f.round
    @lyUniqueVisitors = last_year_result['ga:users'].to_f.round
    @lyPageviews = last_year_result['ga:pageviews'].to_f.round
    @lyPhotoViews = lyphotoViewsGalleries['ga:pageviews'].to_f.round + lyphotoViewsArtists['ga:pageviews'].to_f.round + lyphotoViewsFirstLook['ga:pageviews'].to_f.round
    @lyPPV = last_year_result['ga:pageviewsPerSession'].to_f.round(2)
    @lyBounce = last_year_result['ga:bounceRate'].to_f.round(2)
    @avgLYVisitDuration = Time.at(last_year_result['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgLYVD = last_year_result['ga:avgSessionDuration'].to_f

  #  binding.pry

    # row color logic
    # if TY > LY @row_color = "success"
    # if TY < LY @row_color = "warning"
    # if TY == LY @row_color = "active"
    if @tyVisits > @lyVisits
      @TYrow_color = "success"
    elsif @tyVisits < @lyVisits
      @TYrow_color = "danger"
    else 
      @TYrow_color = "active"
    end

    if @tyUniqueVisitors > @lyUniqueVisitors
      @UVrow_color = "success"
    elsif @tyUniqueVisitors < @lyUniqueVisitors
      @UVrow_color = "danger"
    else 
      @UVrow_color = "active"
    end
      
    if @tyPageviews > @lyPageviews
      @PVrow_color = "success"
    elsif @tyPageviews < @lyPageviews
      @PVrow_color = "danger"
    else 
      @PVrow_color = "active"
    end

    if @tyPhotoViews > @lyPhotoViews
      @PHrow_color = "success"
    elsif @tyPhotoViews < @lyPhotoViews
      @PHrow_color = "danger"
    else 
      @PHrow_color = "active"
    end

    if @tyPPV > @lyPPV
      @PPVrow_color = "success"
    elsif @tyPPV < @lyPPV
      @PPVrow_color = "danger"
    else 
      @PPVrow_color = "active"
    end

    if @tyBounce < @lyBounce
      @Brow_color = "success"
    elsif @tyBounce > @lyBounce
      @Brow_color = "danger"
    else 
      @Brow_color = "active"
    end

    if @avgTYVisitDuration > @avgLYVisitDuration
      @VDrow_color = "success"
    elsif @avgTYVisitDuration < @avgLYVisitDuration
      @VDrow_color = "danger"
    else 
      @VDrow_color = "active"
    end

  end

  def yearly
    time
    visitor

    # YEAR OVER YEAR
    #
    # this year pageviews
    this_year_result2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LY,
    'end-date'   => @today,
    'dimensions' => 'ga:pagepath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
    # 'filters'    => 'ga:pagePath==/url/to/user'
 }).data.totals_for_all_results

    # this month 'galleries'
    photoViewsGalleries2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LY,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # this month 'artists'
    photoViewsArtists2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LY,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this month 'first-look'
    photoViewsFirstLook2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LY,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results


    # this year data variables
    @tyVisits2 = this_year_result2['ga:sessions'].to_f.round
    @tyUniqueVisitors2 = this_year_result2['ga:users'].to_f.round
    @tyPageviews2 = this_year_result2['ga:pageviews'].to_f.round
    @tyPhotoViews2 = photoViewsGalleries2['ga:pageviews'].to_f.round + photoViewsArtists2['ga:pageviews'].to_f.round + photoViewsFirstLook2['ga:pageviews'].to_f.round
    @tyPPV2 = this_year_result2['ga:pageviewsPerSession'].to_f.round(2)
    @tyBounce2 = this_year_result2['ga:bounceRate'].to_f.round(2)
    @avgTYVisitDuration2 = Time.at(this_year_result2['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgTYVD2 = this_year_result2['ga:avgSessionDuration'].to_f


   # binding.pry

    #last year
    last_year_result2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LY2,
    'end-date'   => @LY3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
  }).data.totals_for_all_results

    # this month 'galleries'
    photoViewsGalleries2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LY2,
    'end-date'   => @LY3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # this month 'artists'
    photoViewsArtists2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LY2,
    'end-date'   => @LY3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this month 'first-look'
    photoViewsFirstLook2 = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @LY2,
    'end-date'   => @LY3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results

    # last year data variables
    @lyVisits2 = last_year_result2['ga:sessions'].to_f.round
    @lyUniqueVisitors2 = last_year_result2['ga:users'].to_f.round
    @lyPageviews2 = last_year_result2['ga:pageviews'].to_f.round
    @lyPhotoViews2 = photoViewsGalleries2['ga:pageviews'].to_f.round + photoViewsArtists2['ga:pageviews'].to_f.round + photoViewsFirstLook2['ga:pageviews'].to_f.round
    @lyPPV2 = last_year_result2['ga:pageviewsPerSession'].to_f.round(2)
    @lyBounce2 = last_year_result2['ga:bounceRate'].to_f.round(2)
    @avgLYVisitDuration2 = Time.at(last_year_result2['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgLYVD2 = last_year_result2['ga:avgSessionDuration'].to_f

    # binding.pry

    # row color logic
    # if TY > LY @row_color = "success"
    # if TY < LY @row_color = "warning"
    # if TY == LY @row_color = "active"
    if @tyVisits2 > @lyVisits2
      @TYrow_color2 = "success"
    elsif @tyVisits2 < @lyVisits2
      @TYrow_color2 = "danger"
    else 
      @TYrow_color2 = "active"
    end

    if @tyUniqueVisitors2 > @lyUniqueVisitors2
      @UVrow_color2 = "success"
    elsif @tyUniqueVisitors2 < @lyUniqueVisitors2
      @UVrow_color2 = "danger"
    else 
      @UVrow_color2 = "active"
    end
      
    if @tyPageviews2 > @lyPageviews2
      @PVrow_color2 = "success"
    elsif @tyPageviews2 < @lyPageviews2
      @PVrow_color2 = "danger"
    else 
      @PVrow_color2 = "active"
    end

    if @tyPhotoViews2 > @lyPhotoViews2
      @PHrow_color2 = "success"
    elsif @tyPhotoViews2 < @lyPhotoViews2
      @PHrow_color2 = "danger"
    else 
      @PHrow_color2 = "active"
    end

    if @tyPPV2 > @lyPPV2
      @PPVrow_color2 = "success"
    elsif @tyPPV2 < @lyPPV2
      @PPVrow_color2 = "danger"
    else 
      @PPVrow_color2 = "active"
    end

    if @tyBounce2 < @lyBounce2
      @Brow_color2 = "success"
    elsif @tyBounce2 > @lyBounce2
      @Brow_color2 = "danger"
    else 
      @Brow_color2 = "active"
    end

    if @avgTYVisitDuration2 > @avgLYVisitDuration2
      @VDrow_color2 = "success"
    elsif @avgTYVisitDuration2 < @avgLYVisitDuration2
      @VDrow_color2 = "danger"
    else 
      @VDrow_color2 = "active"
    end


    # MONTH TO DATE
    #
    # this year pageviews
    this_year_result = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @YTD,
    'end-date'   => @today,
    'dimensions' => 'ga:pagepath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
    # 'filters'    => 'ga:pagePath==/url/to/user'
 }).data.totals_for_all_results

    # this year 'galleries'
    photoViewsGalleries = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @YTD,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # this year 'artists'
    photoViewsArtists = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @YTD,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this year 'first-look'
    photoViewsFirstLook = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @YTD,
    'end-date'   => @today,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results

    # this year data variables
    @tyVisits = this_year_result['ga:sessions'].to_f.round
    @tyUniqueVisitors = this_year_result['ga:users'].to_f.round
    @tyPageviews = this_year_result['ga:pageviews'].to_f.round
    @tyPhotoViews = photoViewsGalleries['ga:pageviews'].to_f.round + photoViewsArtists['ga:pageviews'].to_f.round + photoViewsFirstLook['ga:pageviews'].to_f.round
    @tyPPV = this_year_result['ga:pageviewsPerSession'].to_f.round(2)
    @tyBounce = this_year_result['ga:bounceRate'].to_f.round(2)
    @avgTYVisitDuration = Time.at(this_year_result['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgTYVD = this_year_result['ga:avgSessionDuration'].to_f


   # binding.pry

    #last year
    last_year_result = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @YTD2,
    'end-date'   => @YTD3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:sessions, ga:pageviews, ga:users, ga:pageviewsPerSession, ga:bounceRate, ga:avgSessionDuration',
  }).data.totals_for_all_results

    # last year 'galleries'
    lyphotoViewsGalleries = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @YTD2,
    'end-date'   => @YTD3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@galleries'
 }).data.totals_for_all_results

    # last year 'artists'
    lyphotoViewsArtists = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @YTD2,
    'end-date'   => @YTD3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@artists'
 }).data.totals_for_all_results

    # this year 'first-look'
    lyphotoViewsFirstLook = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => @YTD2,
    'end-date'   => @YTD3,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath=@first-look'
 }).data.totals_for_all_results

    # last year data variables
    @lyVisits = last_year_result['ga:sessions'].to_f.round
    @lyUniqueVisitors = last_year_result['ga:users'].to_f.round
    @lyPageviews = last_year_result['ga:pageviews'].to_f.round
    @lyPhotoViews = lyphotoViewsGalleries['ga:pageviews'].to_f.round + lyphotoViewsArtists['ga:pageviews'].to_f.round + lyphotoViewsFirstLook['ga:pageviews'].to_f.round
    @lyPPV = last_year_result['ga:pageviewsPerSession'].to_f.round(2)
    @lyBounce = last_year_result['ga:bounceRate'].to_f.round(2)
    @avgLYVisitDuration = Time.at(last_year_result['ga:avgSessionDuration'].to_f).utc.strftime("%H:%M:%S")
    @avgLYVD = last_year_result['ga:avgSessionDuration'].to_f

  #  binding.pry

    # row color logic
    # if TY > LY @row_color = "success"
    # if TY < LY @row_color = "warning"
    # if TY == LY @row_color = "active"
    if @tyVisits > @lyVisits
      @TYrow_color = "success"
    elsif @tyVisits < @lyVisits
      @TYrow_color = "danger"
    else 
      @TYrow_color = "active"
    end

    if @tyUniqueVisitors > @lyUniqueVisitors
      @UVrow_color = "success"
    elsif @tyUniqueVisitors < @lyUniqueVisitors
      @UVrow_color = "danger"
    else 
      @UVrow_color = "active"
    end
      
    if @tyPageviews > @lyPageviews
      @PVrow_color = "success"
    elsif @tyPageviews < @lyPageviews
      @PVrow_color = "danger"
    else 
      @PVrow_color = "active"
    end

    if @tyPhotoViews > @lyPhotoViews
      @PHrow_color = "success"
    elsif @tyPhotoViews < @lyPhotoViews
      @PHrow_color = "danger"
    else 
      @PHrow_color2 = "active"
    end

    if @tyPPV > @lyPPV
      @PPVrow_color = "success"
    elsif @tyPPV < @lyPPV
      @PPVrow_color = "danger"
    else 
      @PPVrow_color = "active"
    end

    if @tyBounce < @lyBounce
      @Brow_color = "success"
    elsif @tyBounce > @lyBounce
      @Brow_color = "danger"
    else 
      @Brow_color = "active"
    end

    if @avgTYVisitDuration > @avgLYVisitDuration
      @VDrow_color = "success"
    elsif @avgTYVisitDuration < @avgLYVisitDuration
      @VDrow_color = "danger"
    else 
      @VDrow_color = "active"
    end
  end

end