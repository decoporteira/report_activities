class SearchController < ApplicationController
  def index
    clean_query = query_cleaner(params[:query].to_s).downcase

    @students = find_records(Student, clean_query)
    @classrooms = find_records(Classroom, clean_query)
    @teachers = filter_teachers
    @financial_responsibles = find_records(FinancialResponsible, clean_query)
  end

  def filter
    clean_query = query_cleaner(params[:query].to_s).downcase
    @classrooms = Classroom.where('name LIKE ?', "%#{clean_query}%")
    return if params[:teacher_id].blank?

    @classrooms = @classrooms.where(teacher_id: params[:teacher_id])
  end

  private

  def find_records(model, clean_query)
    model.where(
      "TRANSLATE(LOWER(name), 'ÁÀÂÃÄáàâãäÉÈÊËéèêëÍÌÎÏíìîïÓÒÕÔÖóòôõöÚÙÛÜúùûüÇç',
       'AAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuÇc') LIKE ?", "%#{clean_query}%"
    )
  end

  def query_cleaner(query)
    query
      .gsub(/[áàãâä]/, 'a')
      .gsub(/[éèêë]/, 'e')
      .gsub(/[íìîï]/, 'i')
      .gsub(/[óòõôö]/, 'o')
      .gsub(/[úùûü]/, 'u')
  end

  def filter_teachers
    @classrooms.map(&:teacher_id).uniq
  end
end
