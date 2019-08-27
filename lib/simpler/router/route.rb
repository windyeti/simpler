module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        return unless method == @method

        arr_template = @path.split('/')
        arr_path = path.split('/')
        return unless arr_template.size == arr_path.size

        arr_compare = arr_template.map.with_index do |key, i|
          if key.start_with?(':')
            @params[key] = arr_path[i]
            arr_path[i]
          elsif key == arr_path[i]
            arr_path[i]
          else
            nil
          end
        end

        arr_path == arr_compare
      end

    end
  end
end
