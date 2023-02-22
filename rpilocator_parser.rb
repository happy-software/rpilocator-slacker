require 'uri'
require 'net/http'
require 'json'

class BadResponse < StandardError; end

class RpilocatorParser
  def initialize
    @uri = URI('https://rpilocator.com/data.cfm')
    get_results
  end

  def get_results
    @data ||= JSON.parse(curl).fetch("data")
  end

  def get_available
    @data.reject { |d| d.fetch("avail") == "No" }
  end

  private

  def curl
    params = {
      :method => 'getProductTable',
      :token => 'vgmsty3dfhmf282c2hkmmagutxmnxmueuorrtc5c',
      :country => 'US',
      :cat => 'PI4',
      :_ => '1677025282357',
    }
    @uri.query = URI.encode_www_form(params)

    req = Net::HTTP::Get.new(@uri)
    req['authority'] = 'rpilocator.com'
    req['accept'] = 'application/json, text/javascript, */*; q=0.01'
    req['accept-language'] = 'en-US,en;q=0.9'
    req['cookie'] = 'cftoken=0; RPILOCATOR=0; CFTOKEN=0; cfid=cca9df29-f207-412c-9c5f-b75f725fcc6a; CFID=cca9df29-f207-412c-9c5f-b75f725fcc6a'
    req['dnt'] = '1'
    req['referer'] = 'https://rpilocator.com/?country=US&cat=PI4'
    req['sec-ch-ua'] = '"Chromium";v="110", "Not A(Brand";v="24", "Brave";v="110"'
    req['sec-ch-ua-mobile'] = '?0'
    req['sec-ch-ua-platform'] = '"macOS"'
    req['sec-fetch-dest'] = 'empty'
    req['sec-fetch-mode'] = 'cors'
    req['sec-fetch-site'] = 'same-origin'
    req['sec-gpc'] = '1'
    req['user-agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36'
    req['x-requested-with'] = 'XMLHttpRequest'

    req_options = {
      use_ssl: @uri.scheme == 'https'
    }
    res = Net::HTTP.start(@uri.hostname, @uri.port, req_options) do |http|
      http.request(req)
    end
    raise BadResponse.new("Non 200 response code from Rpilocator: #{res}") unless res.code == "200"

    res.body
  end
end
