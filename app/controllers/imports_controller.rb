# frozen_string_literal: true

class ImportsController < ApplicationController
  before_action :import, only: %i[show destroy]

  def new
    @import = Import.new
  end

  def index
    @imports = ::ImportsQuery.new(params).results
  end

  def create
    @import = Import::Create.new(import_permitted_params).call

    if @import.valid?
      ImportWorker.perform_async(@import.id)
      redirect_to @import, flash: { success: 'Import has been successfully created. Processing will start in a minute...' }
    else
      flash.now[:error] = "Couldn't start import for you. There was some errors: #{@import.errors.full_messages.join('; ')}"
      render :new
    end
  end

  def show; end

  def destroy
    @import.csv.purge_later
    @import.destroy

    redirect_to imports_path
  end

  private

  def import
    @import ||= Import.find(params[:id])
  end

  def import_permitted_params
    params.require(:import).permit(:csv)
  end
end
