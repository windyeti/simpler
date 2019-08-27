require 'logger'
require_relative 'simpler/view'

class AppLogger
  def initialize(app, option)
    @app = app
    @logger = Logger.new(option[:path])
    @route = nil
  end

  def call(env)
    status, headers, body = @app.call(env)

    if status != 404
      write_log(env, status, headers)
    else
      write_error_log(env)
    end

    [status, headers, body]
  end

  private

  def write_log(env, status, headers)
    result_for_log = make_log(env)
    result_for_log += "Response: #{status} [#{headers["Content-Type"]}] #{path_to_view(headers["Content-Type"])}"
    @logger.info(result_for_log)
  end

  def make_log(env)
    @route = Simpler.application.router.route_for(env)

    "\nRequest: #{env['REQUEST_METHOD']} #{env["REQUEST_URI"]}
Handler: #{@route.controller.name}#""#{@route.action}
Parameters: #{Rack::Utils.parse_nested_query(env["QUERY_STRING"])}\n"
  end

  def write_error_log(env)
    @logger.info("\nRequest: #{env['REQUEST_METHOD']} #{env["REQUEST_URI"]}
Handler: not found
Parameters: #{Rack::Utils.parse_nested_query(env["QUERY_STRING"])}
Response: 404\n")
  end

  def path_to_view(header_type)
    controller = @route.controller.name
    controller.slice!('Controller')
    folder_name = controller.downcase
    header_type == 'text/html' ? "#{folder_name}/#{@route.action}.html.erb" : ''
  end
end

