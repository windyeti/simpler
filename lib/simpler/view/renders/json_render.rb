module Simpler
  class View
    class Render
      class JsonRender
        def initialize(env)
          @env = env
        end

        def result
          @env['simpler.template'][:json]
        end
      end
    end
  end
end
