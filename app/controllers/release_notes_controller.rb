class ReleaseNotesController < ApplicationController
  def index
    @release_notes = ReleaseNote.latest.page(params[:page])
  end
end
