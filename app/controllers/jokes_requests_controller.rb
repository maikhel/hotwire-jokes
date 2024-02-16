class JokesRequestsController < ApplicationController
  before_action :set_jokes_request, only: %i[ show edit update destroy ]

  def index
    @jokes_requests = JokesRequest.all.order(id: :asc)
  end

  def show
    @jokes = @jokes_request.jokes.order(id: :asc)
  end

  def new
    @jokes_request = JokesRequest.new
  end

  def edit
  end

  def create
    @jokes_request = JokesRequest.new(jokes_request_params)

    respond_to do |format|
      if @jokes_request.save
        FetchJokesJob.perform_later(@jokes_request.id)
        format.html { redirect_to jokes_request_url(@jokes_request), notice: "Jokes request was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @jokes_request.update(jokes_request_params)
        format.html { redirect_to jokes_requests_path, notice: "Jokes request was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Jokes request was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @jokes_request.destroy!

    respond_to do |format|
      format.html { redirect_to jokes_requests_url, notice: "Jokes request was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Jokes request was successfully destroyed." }
    end
  end

  private
    def set_jokes_request
      @jokes_request = JokesRequest.find(params[:id])
    end

    def jokes_request_params
      params.require(:jokes_request).permit(:amount, :delay)
    end
end
