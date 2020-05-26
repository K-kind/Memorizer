class Admin::ReleaseNotesController < AdminController
  before_action :set_release_note, only: [:show, :update, :destroy]

  def index
    @release_notes = ReleaseNote.order(release_date: :desc).page(params[:page])
    @new_release = ReleaseNote.new
  end

  def show; end

  def create
    @new_release = ReleaseNote.new
    @new_release = ReleaseNote.new(release_note_params)
    if @new_release.save
      redirect_to admin_release_note_url(@new_release)
    else
      @release_notes = ReleaseNote.order(created_at: :desc).page(params[:page])
      render 'index'
    end
  end

  def update
    if @release_note.update(release_note_params)
      redirect_to admin_release_note_url(@release_note)
    else
      render 'show'
    end
  end

  def destroy
    @release_note.destroy
    redirect_to admin_release_notes_url
  end

  private

  def release_note_params
    params.require(:release_note).permit(:content, :version, :year, :month, :day)
  end

  def set_release_note
    @release_note = ReleaseNote.find(params[:id])
  end
end
