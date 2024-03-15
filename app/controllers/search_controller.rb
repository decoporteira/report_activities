class SearchController < ApplicationController
  def index
    query = params[:query].to_s
    @students = Student.where('name LIKE ?', "%#{ActiveRecord::Base.sanitize_sql_like(query)}%")
    @teachers = Teacher.where(name: query)
    @classrooms = Classroom.where(name: query)
    # @q = Student.ransack(name_cont: normalized_search_term)
    # @students = @q.result(distinct: true)
    # @q = Classroom.ransack(params[:q])
    # @classrooms = @q.result(distinct: true)
    # @teachers = filter_teachers
  end

  # def filter
  #   # Cria a busca Ransack com base nos parâmetros passados
  #   @q = Classroom.ransack(params[:q])

  #   # Obtém os resultados da busca Ransack
  #   @classrooms = @q.result(distinct: true)

  #   # Filtra os resultados adicionais, se necessário
  #   return if params[:teacher_id].blank?

  #   @classrooms = @classrooms.where(teacher_id: params[:teacher_id])
  # end

  private

  def filter_teachers
    teachers = []
    @classrooms.each do |classroom|
      teachers << classroom.teacher_id
    end
    teachers.uniq
  end

end
