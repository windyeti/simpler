class TestsController < Simpler::Controller

  def index
    # render 'tests/list'
    render plain: "----- Plain text response. Index ----\n"
    @time = Time.now
  end

  def create
  end

  def show
    @id = params
  end

  def list

  end

end
