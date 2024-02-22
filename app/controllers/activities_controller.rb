class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show edit update destroy]
  before_action :set_info
  before_action :admin?

  def index
    @activities = Activity.all
  end

  def show; end

  def new
    @activity = Activity.new
  end

  def edit; end

  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to activity_url(@activity), notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to activity_url(@activity), notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def another_update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to activity_url(@activity), notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_late_to_missing
    activities = Activity.where(student_id: params[:items][:student_id], date: params[:items][:date])
    activities.each do |item|
      item.update(late: 'ausente')
    end
    student = Student.find(params[:items][:student_id])
    classroom = Classroom.find(student.classroom_id)
    redirect_to classroom, notice: 'Atividades marcadas como Ausente.'
  end

  def update_late
    activity = Activity.find(params[:items][:activity_id])
    activity.update(late: params[:items][:late])
    student = Student.find(activity.student_id)
    classroom = Classroom.find(student.classroom_id)
    redirect_to classroom, notice: 'Atividade atualizada com sucesso.'
  end

  private

  def set_info
    @students = Student.all
    @classrooms = Classroom.all
  end

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:report, :late, :missing, :student_id, :date)
  end

  def admin?
    redirect_to root_path, alert: 'Você não possui acesso.' unless current_user.admin? || current_user.accounting? || current_user.teacher?
  end
end
