require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params)
    puts req.header
    @req = req
    @res = res
    @already_built_response = false
    puts req.query_string
    session
    @params = Params.new(req, route_params).params
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    raise 'error' if @already_built_response
    res.set_redirect WEBrick::HTTPStatus::TemporaryRedirect,url

    @session.store_session(@res)
    @already_built_response = true
  end

  def render_content(content, type)
    raise 'error' if @already_built_response
    @res.content_type = type
    @res.body = content

    @session.store_session(@res)
    @already_built_response = true
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore

    contents = File.read("../views/#{controller_name}/#{template_name}.html.erb")
    results = ERB.new(contents).result(binding)
    render_content(results, "text/html")
  end

  def invoke_action(name)

  end
end
