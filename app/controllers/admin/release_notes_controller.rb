class Admin::ReleaseNotesController < AdminController
  before_action :set_release_note, only: [:show, :update, :destroy]

  def index
    @release_notes = ReleaseNote.order(created_at: :desc).page(params[:page])
    @new_release = ReleaseNote.new
  end

  def show; end

  def create
    @new_release = ReleaseNote.new(content_params)
  end

  def update

  end

  def destroy

  end

  private

  def release_note_params
    params.requre(:release_note).permit(:content, :version, :month, :date)
  end

  def set_release_note
    @release_note = ReleaseNote.find(params[:id])
  end
end
