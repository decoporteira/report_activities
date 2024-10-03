class SearchController < ApplicationController
  def index
    query = params[:query].to_s

    @students =
    Student.where(
      "TRANSLATE(LOWER(name), 'ÁÀÂÃÄáàâãäÉÈÊËéèêëÍÌÎÏíìîïÓÒÕÔÖóòôõöÚÙÛÜúùûüÇç', 
       'AAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuÇc') LIKE ?", 
       "%#{query.downcase}%"
    )
    @classrooms =
      Classroom.where(
        "TRANSLATE(LOWER(name), 'ÁÀÂÃÄáàâãäÉÈÊËéèêëÍÌÎÏíìîïÓÒÕÔÖóòôõöÚÙÛÜúùûüÇç', 
         'AAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuÇc') LIKE ?", 
         "%#{query.downcase}%"
      )
    @teachers = filter_teachers
    @financial_responsibles =
      FinancialResponsible.where(
        'LOWER(name) LIKE ?',
        "%#{query_sem_acento.downcase}%"
      )
  end

  def filter
    query = params[:query].to_s
    query_sem_acento = substitui_vogais_com_acento(query)
    @classrooms = Classroom.where( "TRANSLATE(LOWER(name), 'ÁÀÂÃÄáàâãäÉÈÊËéèêëÍÌÎÏíìîïÓÒÕÔÖóòôõöÚÙÛÜúùûüÇç', 
    'AAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuÇc') LIKE ?", 
    "%#{query.downcase}%")
    return if params[:teacher_id].blank?

    @classrooms = @classrooms.where(teacher_id: params[:teacher_id])
  end

  private

  def filter_teachers
    teachers =
      @classrooms.each_with_object([]) do |classroom, teachers|
        teachers << classroom.teacher_id
      end
    teachers.uniq
  end
end
