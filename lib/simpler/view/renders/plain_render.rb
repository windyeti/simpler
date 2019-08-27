module Simpler
  class View
    class Render
      class PlainRender
        def initialize(env)
          @env = env
        end

        def result
          @env['simpler.template'][:plain]
        end
      end
    end
  end
end
