class SearchController < ApplicationController
  def index
    @q = Student.ransack(params[:q])
    @students = @q.result(distinct: true)
    @q = Classroom.ransack(params[:q])
    @classrooms = @q.result(distinct: true)
  end
end
