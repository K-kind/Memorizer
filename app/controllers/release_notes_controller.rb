class ReleaseNotesController < ApplicationController
  def index
    @release_notes = ReleaseNote.latest.page(params[:page]).per(5)
  end

  def show
    @release_note = ReleaseNote.find(params[:id])
  end
end
