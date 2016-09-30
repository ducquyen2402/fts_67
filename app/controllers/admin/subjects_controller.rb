class Admin::SubjectsController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :find_subject, except: [:index, :new, :create]

  def index
    @subject = Subject.new
    @subjects = if params[:find]
      Subject.search(search_params)
        .paginate page: params[:page], per_page: Settings.subjects
    else
      Subject.all
    end
  end

  def show
    @activities = @subject.activities
    @questions = if params[:find]
      @subject.questions.search(search_params)
        .paginate page: params[:page], per_page: Settings.questions
    else
      @subject.questions.all
    end
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new subject_params
    current_user.generate_activity "created", @subject
    if @subject.save
      flash.now[:success] = t "subject.success"
      redirect_to admin_subject_path @subject
    else
      flash.now[:danger] = t "subject.fail"
      render :new
    end
  end

  def edit
  end

  def update
    if @subject.update_attributes subject_params
      current_user.generate_activity "updated", @subject
      flash[:success] = t "subject.updated"
      redirect_to admin_subjects_url
    else
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      current_user.generate_activity "deleted", @subject
      flash[:success] = t "subject.success"
      redirect_to admin_subjects_url
    else
      flash[:danger] = t "subject.danger"
      redirect_to root_url
    end
  end

  private
  def subject_params
    params.require(:subject).permit :name, :duration, :description
  end

  def search_params
    params.permit :subject_id, :search
  end

  def find_subject
    @subject = Subject.find_by id: params[:id]
    if @subject.nil?
      flash[:danger] = t "find_subject.danger"
      redirect_to root_url
    end
  end
end
