class AddressesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_addressable, only: %i[new create show update edit]
  before_action :set_addresses, only: %i[show update]

  def index
    @addresses = Address.all
  end

  def new
    @address = if @student.nil?
                 @teacher.addresses.build
               else
                 @student.addresses.build
               end
  end

  def show; end

  def edit
    if params.key?('student_id')
      @teacher = nil
      @student = Student.find(params[:student_id])
    else
      @student = nil
      @teacher = Teacher.find(params[:teacher_id])
    end
    @address = Address.find(params[:id])
  end

  def create
    if @student.nil?
      @address = @teacher.addresses.build(address_params)
      if @address.save
        redirect_to teacher_path(@teacher), notice: t('.success')
      else
        render :new
      end
    else
      @address = @student.addresses.build(address_params)
      if @address.save
        redirect_to student_path(@student), notice: t('.success')
      else
        render :new
      end
    end
  end

  def update
    if params.key?('student_id')
      @teacher = nil
      @student = Student.find(params[:student_id])
      @address = Address.find(params[:id])
      if @address.update(address_params)
        redirect_to student_path(@student), notice: t('.success')
      else
        render :new, notice: t('.fail')
      end
    else
      @student = nil
      @teacher = Teacher.find(params[:teacher_id])
      @address = Address.find(params[:id])
      if @address.update(address_params)
        redirect_to teacher_path(@teacher), notice: t('.success')
      else
        render :new
      end
    end
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: t('.denied') unless current_user.admin? || current_user.accounting?
  end

  def address_params
    params.require(:address).permit(:street, :number, :unit, :neighborhood, :city, :state, :country, :zip_code)
  end

  def set_addressable
    if params.key?('student_id')
      @teacher = nil
      @student = Student.find(params[:student_id])
    else
      @student = nil
      @teacher = Teacher.find(params[:teacher_id])
    end
  end

  def set_addresses
    @addresses = if params.key?('student_id')
                   Address.find_by(addressable_id: params[:student_id])
                 else
                   Address.find_by(addressable_id: params[:teacher_id])
                 end
  end
end
