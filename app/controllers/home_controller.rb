class HomeController < ApplicationController
  before_action :get_students
  before_action :get_classrooms
  before_action :get_activities

  def get_students
    @students = Student.all
  end

  def get_classrooms
    @classrooms = Classroom.all
  end

  def get_activities
    @activities = Activity.all
  end

end
