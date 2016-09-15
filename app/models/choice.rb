class Choice < ApplicationRecord
  belongs_to :exam
  belongs_to :question
  belongs_to :answer, optional: true
end
