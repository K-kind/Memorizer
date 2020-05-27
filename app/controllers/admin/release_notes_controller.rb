class Admin::ReleaseNotesController < AdminController
  before_action :set_release_note, only: [:show, :update, :destroy]

  def index
    @release_notes = ReleaseNote.latest.page(params[:page])
    @new_release = ReleaseNote.new
  end

  def show
    @release_note.set_date_variables
  end

  def create
    @new_release = ReleaseNote.new
    @new_release = ReleaseNote.new(release_note_params)
    @new_release.set_release_date
    if @new_release.save
      flash[:notice] = 'リリースノートを発行しました。'
      redirect_to admin_release_note_url(@new_release)
    else
      @release_notes = ReleaseNote.order(created_at: :desc).page(params[:page])
      render 'index'
    end
  end

  def update
    @release_note.attributes = release_note_params
    @release_note.set_release_date
    if @release_note.save
      flash[:notice] = 'リリースノートを変更しました。'
      redirect_to admin_release_note_url(@release_note)
    else
      render 'show'
    end
  end

  def destroy
    @release_note.destroy
    flash[:notice] = 'リリースノートを削除しました。'
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
