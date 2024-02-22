class HomeController < ApplicationController
  before_action :set_students
  before_action :set_classrooms
  before_action :set_activities

  def set_students
    @students = Student.where(status: 'Matriculado')
    @total_students = @students.count
  end

  def set_classrooms
    @classrooms = Classroom.all
  end

  def set_activities
    @activities = Activity.all
  end
end
