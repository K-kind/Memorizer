class ReleaseNotesController < ApplicationController
  def index
    @release_notes = ReleaseNote.latest.page(params[:page])
  end

  def show
    @release_note = ReleaseNote.find(params[:id])
  end
end
