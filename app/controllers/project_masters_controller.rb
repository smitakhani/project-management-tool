class ProjectMastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project_master, only: %i[ show edit update destroy ]

  # GET /project_masters or /project_masters.json
  def index
    
    if current_user.has_role? :admin
     @project_masters = ProjectMaster.with_deleted.order('expected_duration')
     
    else
     @project_masters = current_user.project_masters.order('expected_duration')
     authorize @project_masters
    end
  end

  # GET /project_masters/1 or /project_masters/1.json
  def show
    authorize @project_master
    @task = @project_master.tasks.build
  end

  # GET /project_masters/new
  def new
    @users = User.with_deleted.order(created_at: :desc)
    @project_master = ProjectMaster.new
    authorize @project_master
    @clients = Client.order(created_at: :desc)
  end

  # GET /project_masters/1/edit
  def edit
    @users = User.order(created_at: :desc)
  end

  # POST /project_masters or /project_masters.json
  def create
    @project_master = ProjectMaster.new(project_master_params)
    # @project_master = current_user.project_masters.build(project_master_params)
    authorize @project_master
    respond_to do |format|
      if @project_master.save
        ProjectMasterMailer.with(project_master: @project_master).new_project_master_email.deliver_later
        format.html { redirect_to project_master_url(@project_master), notice: "Project  was successfully created." }
        format.json { render :show, status: :created, location: @project_master }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_masters/1 or /project_masters/1.json
  def update

    # @project_master =  ProjectMaster.with_deleted.find(params[:id])
      if @project.deleted_at.nil?
        respond_to do |format|
          authorize @project_master
          if @project_master.update(project_master_params)
            format.html { redirect_to project_master_url(@project_master), notice: "Project  was successfully updated." }
            format.json { render :show, status: :ok, location: @project_master }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @project_master.errors, status: :unprocessable_entity }
          end
        end
      else
        @project.restore
        redirect_to project_masters_path, notice: "Project was successfully restored."
      end


   
  end

  # DELETE /project_masters/1 or /project_masters/1.json
  def destroy
    @project_master.destroy

    respond_to do |format|
      format.html { redirect_to project_masters_url, notice: "Project master was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_master
      @project_master = ProjectMaster.with_deleted.find(params[:id])
      @project = ProjectMaster.with_deleted.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_master_params
      params.require(:project_master).permit(:name, :description ,:user_id, :ptype ,:client_id,:client_requirements,:budget,:phase,{:technology => []},:start_date,:end_date,:expected_duration)
    end
end
