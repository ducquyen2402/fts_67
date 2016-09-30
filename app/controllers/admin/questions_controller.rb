class Admin::QuestionsController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :find_question, except: [:new, :create, :index]
  before_action :load_subjects, only: [:new, :show]

  def show
  end

  def new
    @question = Question.new
    Settings.number_of_answers.times {@question.answers.build}
  end

  def create
    @question = Question.new question_params
    if @question.save
      @subject = @question.subject
      current_user.generate_activity "created", @question
      flash[:success] = t "question.created_success"
      redirect_to admin_subject_path @subject
    else
      load_subjects
      flash[:danger] = t "question.created_fail"
      render :new
    end
  end

  def update
    if @question.update_attributes question_params
      current_user.generate_activity "updated", @question
      flash[:success] = t "question.update_success"
      redirect_to admin_question_path @question
    else
      load_subjects
      render :show
    end
  end

  def destroy
    if @question.destroy
      current_user.generate_activity "deleted", @question
      flash[:success] = t "question.destroy_success"
      redirect_to admin_questions_path
    else
      flash[:danger] = t "question.destroy_fail"
      redirect_to root_url
    end
  end

  private
  def question_params
    params.require(:question).permit :id, :content, :subject_id,
      answers_attributes: [:id, :content, :is_correct, :_destroy]
  end

  def find_question
    @question = Question.find_by id: params[:id]
    if @question.nil?
      flash[:danger] = t "question.nil"
      redirect_to root_url
    end
  end
end
