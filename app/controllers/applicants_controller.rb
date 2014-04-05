class ApplicantsController < ApplicationController
  before_action :set_applicant, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:index, :destroy]

  # GET /applicants
  def index
    @applicants = Applicant.all
  end

  # GET /applicants/1
  def show
  end

  # GET /applicants/new
  def new
    @applicant = Applicant.new
    professor = Professor.new
    position = @applicant.positions.build
    position.professor = professor
  end

  # GET /applicants/1/edit
  def edit
    professor = Professor
    position = @applicant.positions.build
    positions.professor = professor
  end

    # PATCH/PUT /applicants/1
  def update
    @applicant.positions.each do |position|
      professor = Professor.find_by_email(position.professor.email)
      position.professor = professor if professor
    end
  end

  # POST /applicants
  def create
    @applicant = Applicant.new(applicant_params)

    @applicant.positions.each do |position|
      professor = Professor.find_by_email(position.professor.email)
      position.professor = professor if professor
    end

    if @applicant.save
      begin
        ApplicantMailer.account_email(@applicant).deliver
        @applicant.positions.each do |position|
          next if position.professor_emailed
          professor = position.professor
          ProfessorMailer.pending_recommendation(professor).deliver
          position.professor_emailed = true
        end
      rescue Errno::ECONNREFUSED
        redirect_to @applicant,
          notice: 'Your application was saved but the emails failed to send. Save this URL and contact the ASC for assistance'
      else
        redirect_to @applicant, notice: 'Your application was saved succesfully'
      end
    else
      render action: 'new'
    end
  end

  # DELETE /applicants/1
  def destroy
    @applicant.destroy
    redirect_to applicants_url,
      notice: 'Applicant was successfully deleted.'
  end

  # PATCH/PUT /applicants/1
  def update
    if @applicant.update(applicant_params)
      redirect_to @applicant, notice: 'Applicant was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_applicant
      @applicant = Applicant.find_by_identifier(params[:id])
      raise ActiveRecord::RecordNotFound.new('Application not found') if @applicant.nil?
    end

    # Only allow a trusted parameter "white list" through.
    def applicant_params
      params.require(:applicant).permit(:name, :email, :wuid, :phone_number, :class_standing, :gpa, :comment, :major, :minor, :work_study, :interviewed, :asc_comments, positions_attributes: [:course_id, professor_attributes: [:name, :email]])
    end
end
