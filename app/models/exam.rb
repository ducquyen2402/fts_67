class Exam < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  has_many :choices, dependent: :destroy

  before_create :create_choice

  enum status: [:start, :testing, :unchecked, :checked]

  accepts_nested_attributes_for :choices

  validates :subject_id, presence: true

  def remaning_time
    end_time_calculate unless end_time
    end_time - Time.now
  end

  private
  def create_choice
    questions = subject.questions.shuffle.take Settings.exam_questions
    questions.each do |question|
      self.choices.build question: question
    end
  end

  def end_time_calculate
    end_time = Time.now + subject.duration * 60
  end
end
