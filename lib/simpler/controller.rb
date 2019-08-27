require_relative 'view'

module Simpler
  class Controller

    attr_reader :name

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'] = params

      send(action)
      set_status
      set_headers
      write_response

      @response.finish
    end


    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_status
      template = @request.env['simpler.template']
      @response.status = @request.env['simpler.template'][:status] if !template.nil? && template.has_key?(:status)
    end

    def set_headers
      template = @request.env['simpler.template']

      return @response['Content-Type'] = 'text/plain' if !template.nil? && template.has_key?(:plain)
      return @response['Content-Type'] = 'text/json' if !template.nil? && template.has_key?(:json)
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
