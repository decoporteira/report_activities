class SearchController < ApplicationController
  def index
    query = params[:query].to_s

    query_sem_acento = substitui_vogais_com_acento(query)

    @students = Student.where("name LIKE ?", "%#{query_sem_acento}%")
    @teachers = Teacher.where(name: query)
    @classrooms = Classroom.where(name: query)
    # @q = Student.ransack(name_cont: normalized_search_term)
    # @students = @q.result(distinct: true)
    # @q = Classroom.ransack(params[:q])
    # @classrooms = @q.result(distinct: true)
    # @teachers = filter_teachers
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
