class ImportsController < ApplicationController
  before_action :import, only: [:show]

  def new
    @import = Import.new
  end

  def index
    # @todo: add implementation
  end

  def create
    @import = Import::Create.new(permitted_params).call

    if @import.valid? && @import.csv.attached?
      redirect_to @import, flash: { success: 'Import has been successfully created. Processing will start in a minute...' }
    else
      flash.now[:error] = "Couldn't start import for you. There was some errors: #{@import.errors.full_messages.join('; ')}"
      render :new
    end
  end

  def show
    import = Import.find(params[:id])

    render locals: { import: import }
  end

  private

  def import
    @import ||= Import.find(params[:id])
  end

  def permitted_params
    params.require(:import).permit(:csv)
  end
end
