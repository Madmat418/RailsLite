require 'webrick'


class ControllerBase
  attr_reader :req, :res
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  def render_content(body, content_type)
    raise 'error' if @already_built_response
    @res.content_type = content_type
    @res.body = body

    @already_built_response = true
  end

  def redirect_to(url)
    raise 'error' if @already_built_response
    res.set_redirect WEBrick::HTTPStatus::TemporaryRedirect,url
    @already_built_response = true
  end
end




# root = File.expand_path '/'
# server = WEBrick::HTTPServer.new :Port => 8080, :Root => root
#
# trap 'INT' do server.shutdown end
# server.mount_proc '/' do |req, res|
#   ControllerBase.new(req,res)
# end
#
#
# server.start

