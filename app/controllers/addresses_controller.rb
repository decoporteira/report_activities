class AddressesController < ApplicationController
	before_action :authorize_admin!
	before_action :set_addressable, only: [:new, :create, :show, :update, :edit]
	before_action :set_addresses, only: [:show, :update]

	def index
		@addresses = Address.all
	end

	def new
		if @student.nil?
			@address = @teacher.addresses.build
		else
			@address = @student.addresses.build
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
				redirect_to info_student_path(@teacher), notice: "Endereço cadastrado com sucesso."
			else
				render :new
			end
		else
				@address = @student.addresses.build(address_params)
				if @address.save
					redirect_to info_student_path(@student), notice: "Endereço cadastrado com sucesso."
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
				redirect_to info_student_path(@student), notice: "Endereço foi editado com sucesso." 
			else
				render :new
			end
		else
			@student = nil
			@teacher = Teacher.find(params[:teacher_id])
			@address = Address.find(params[:id])
			if @address.update(address_params)
				redirect_to info_teacher_path(@teacher), notice: "Endereço foi editado com sucesso." 
			else
				render :new
			end
		end
	end

private

	def authorize_admin!
		redirect_to root_path, alert: 'Access denied.' unless current_user.admin? || current_user.accounting?
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
		if params.key?('student_id')
			@addresses = Address.find_by(addressable_id: params[:student_id])
		else
			@addresses = Address.find_by(addressable_id: params[:teacher_id])
		end
	end
end
