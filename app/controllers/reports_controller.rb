class ReportsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :fill_form

  # GET /reports/filter
  def new
    @values = params
  end

  # GET /reports
  def index
    # TODO: Carry over params when hitting sort button
    app_params_trimmed = app_params.delete_if {|k, v| v.empty?}
    app_filter = { applicants: app_params_trimmed } unless app_params_trimmed.empty?
    pos_params_trimmed = pos_params.delete_if {|k, v| v.empty?}
    pos_filter = { positions: pos_params_trimmed } unless pos_params_trimmed.empty?

    @applicants = Applicant.where(app_filter).joins(:positions).where(pos_filter).distinct.page(params[:page]).order(sort_column + ' ' + sort_direction)
  end

  private
    def sort_column
      Applicant.column_names.include?(params[:sort]) ? params[:sort] : 'name'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end

    def fill_form
    end

    def app_params
      params.permit(:name, :wuid, :email, :interviewed, :work_study, class_standing: [])
    end

    def pos_params
      params.permit(referred: [], application_status: [], course_id: [])
    end
end
