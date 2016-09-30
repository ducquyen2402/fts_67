class ExamsController < ApplicationController
  before_action :logged_in_user
  before_action :load_subjects, only: :new
  before_action :find_exam, only: :update

  def index
    @exams = current_user.exams.paginate page: params[:page],
      per_page: Settings.exams_perpage
  end

  def new
    @exam = Exam.new
  end

  def create
    @exam = current_user.exams.new exam_params
    if @exam.save
      flash[:success] = t "exam.create_success"
    else
      flash[:danger] = t "exam.create_error"
    end
    redirect_to root_path
  end

  def show
    @exam = Exam.includes(choices: [{question: :answers},
      :answer]).find_by_id params[:id]
    if @exam.nil?
      flash[:danger] = t"exam.not_found"
      redirect_to exams_path
    end
    if @exam.start?
      time = Time.now + @exam.subject.duration * 60
      @exam.update_attributes status: 1, end_time: time
    end
  end

  def update
    if @exam.update_attributes exam_params
      if params[:finish] && @exam.testing?
        @exam.unchecked!
      end
    else
      flash[:danger] = t "exam.invalid_update"
    end
    redirect_to exams_path
  end

  private
  def find_exam
    @exam = Exam.find_by_id params[:id]
    if @exam.nil?
      flash[:danger] = t "exam.not_found"
      redirect_to exams_path
    end
  end

  def exam_params
    params.require(:exam).permit :subject_id,
      choices_attributes: [:id, :answer_id, :question_id]
  end
end
