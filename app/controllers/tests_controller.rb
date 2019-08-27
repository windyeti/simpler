class TestsController < Simpler::Controller

  def index
    render 'tests/list'
    # render plain: "----- Plain text response. Index ----\n", status: 201
    @time = Time.now
  end

  def create
  end

  def show
    @params = params
  end

  def list

  end

end
