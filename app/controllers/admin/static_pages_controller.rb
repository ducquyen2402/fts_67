class Admin::StaticPagesController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_subjects

  def index
    @exams = Exam.unchecked.includes(:subject).order updated_at: :desc
    @suggest_questions = SuggestQuestion.unapproved
      .includes(:subject).order updated_at: :desc
    @activities = Activity.includes(:user, :activable)
  end
end
