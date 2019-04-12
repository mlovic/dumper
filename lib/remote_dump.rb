#require 'net/http'

class RemoteDump
  REMOTE_URI = ''

  def initialize(text)
    @text = text
  end

  def call
    uri    = URI.parse(REMOTE_URI)
    params = {"msg" => @text, "apikey" => ENV["API_KEY"]}

    case Net::HTTP.post_form(uri, params).status
    when /2../
      "Success"
    when /403/
      "Invalid credentials!"
    when /5../
      "Server error!"
    else
      "Don't know what happened..."
    end
  end
end
