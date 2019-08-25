require 'logger'
require_relative 'simpler/view'

class AppLogger
  def initialize(app, option)
    @app = app
    @logger = Logger.new(option[:path])
  end

  def call(env)
    @request = Rack::Request.new(env)
    result_for_log = writer_result_request(@request)

    status, headers, body = @app.call(env)

    path = Simpler::View.new(@request.env).template_path_relative
    path = path.empty? ? '' : "#{path}.html.erb"
    result_for_log += "Response: #{status} [#{headers["Content-Type"]}] #{path}"

    @logger.info(result_for_log)
    [status, headers, body]
  end

  def writer_result_request(request)
    route = Simpler.application.router.route_for(request.env)

    "\nRequest: #{request.env['REQUEST_METHOD']} #{request.env["REQUEST_URI"]}
Handler: #{route.controller.name}#""#{route.action}
Parameters: #{request.params}\n"
  end
end

