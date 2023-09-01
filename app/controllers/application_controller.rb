class ApplicationController < ActionController::Base
    before_action :set_query
    before_action :authenticate_user!
    #layout :determine_layout
    def set_query
        @q = Student.ransack(params[:q])
        @student = @q.result(distinct: true)
    end
    
end
