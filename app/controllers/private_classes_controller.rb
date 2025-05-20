class PrivateClassesController < ApplicationController

  def index
    @private_lessons = PrivateLesson.all
  end

end