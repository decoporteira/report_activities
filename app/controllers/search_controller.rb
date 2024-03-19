class SearchController < ApplicationController
  def index
    query = params[:query].to_s
    query_sem_acento = substitui_vogais_com_acento(query)

    @students = Student.where('name LIKE ?', "%#{query_sem_acento}%")
    @classrooms = Classroom.where('name LIKE ?', "%#{query_sem_acento}%")
    @teachers = filter_teachers
  end

  def filter
    query = params[:query].to_s
    query_sem_acento = substitui_vogais_com_acento(query)
    @classrooms = Classroom.where('name LIKE ?', "%#{query_sem_acento}%")
    return if params[:teacher_id].blank?

    @classrooms = @classrooms.where(teacher_id: params[:teacher_id])
  end

  private

  def substitui_vogais_com_acento(query)
    query.gsub(/[áàãâäéèêëíìîïóòõôöúùûüÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜ]/, '_').gsub(/[aeiouAEIOU]/, '_')
  end

  def filter_teachers
    teachers = []
    @classrooms.each do |classroom|
      teachers << classroom.teacher_id
    end
    teachers.uniq
  end
end
