class ApplicationController < ActionController::Base
    before_action :set_query

    def set_query
        @q = Student.ransack(params[:q])
        @student = @q.result(distinct: true)
    end
end
