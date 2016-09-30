class Admin::ExamsController < ApplicationController
  before_action :find_exam, only: :update

  def index
    @exams = Exam.paginate page: params[:page],
      per_page: Settings.exams_perpage
  end

  def show
    @exam = Exam.includes(choices: [:answer,
      question: :answers]).find_by_id params[:id]
    if @exam.nil?
      flash[:danger] = t "exam.not_found"
      redirect_to admin_home_path
    end
  end

  def update
    if @exam.update_attributes exam_params
      @exam.checked!
      flash.now[:sucess] = t "exam.checked"
    else
      flash.now[:danger] = t "exam.not_checked"
    end
    redirect_to admin_home_path
  end

  private
  def find_exam
    @exam = Exam.find_by_id params[:id]
    if @exam.nil?
      flash[:danger] = t "exam.not_found"
      redirect_to admin_home_path
    end
  end

  def exam_params
    params.require(:exam).permit :subject_id,
      choices_attributes: [:id, :is_correct]
  end
end
