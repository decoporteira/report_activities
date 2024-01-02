class Resume < ApplicationRecord
  belongs_to :student
  enum status: { 'oculto': 1, 'ativo': 2 }

  #validate :only_one_report


  def only_one_report
    resumes = Resume.where(student_id: self.student_id)
    if resumes.count > 1 
      errors.add(:base, "Apenas um reporst.")
    end
  end
end
