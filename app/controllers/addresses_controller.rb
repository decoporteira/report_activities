class AddressesController < ApplicationController
    before_action :authorize_admin!
    before_action :set_student, only: [:new, :create, :show, :edit, :update]
    before_action :set_address, only: [:show, :edit, :update]
   
    def index
        @addresses = Address.all
    end

    def new
        @address = Address.new
    end

    def show
    
    end

    def edit
       
    end

    def create
        @address = Address.new(address_params)
        @address.student_id = @student.id
        if @address.save
            redirect_to info_student_path(@student), notice: "Endereço cadastrado com sucesso."
        else
            render :new
      end
    end

    def update
        if @address.update(address_params)
            redirect_to info_student_path(@student), notice: "Endereço foi editado com sucesso." 
        else
            render :new
        end
      end

    private

    def authorize_admin!
        redirect_to root_path, alert: 'Access denied.' unless current_user.admin? || current_user.accounting?
    end

    def address_params
        params.require(:address).permit(:street, :number, :unit, :neighborhood, :city, :state, :country, :zip_code)
    end

    def set_student
        @student = Student.find(params[:student_id])
    end

    def set_address
        @address = Address.find_by(student_id: params[:student_id])
    end
end