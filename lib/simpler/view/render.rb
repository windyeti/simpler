require_relative 'renders/erb_render'
require_relative 'renders/json_render'
require_relative 'renders/plain_render'

module Simpler
  class View
    class Render
      def initialize(env, template_path, binding)
        @env = env
        @template_path = template_path
        @binding = binding
      end

      def render
        template = @env['simpler.template']

        return PlainRender.new(@env).result if !template.nil? && template.has_key?(:plain)
        return JsonRender.new(@env).result if !template.nil? && template.has_key?(:json)
        ErbRender.new(@template_path).result(@binding)
      end
    end
  end
end
