class Legal::NcServicesController < ApplicationController
  authorize_resource class: 'NcService'
  respond_to :json

  def index
    @search = NcService.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @services = @search.result(distinct: true).where(nc_service_type_id: service_type_id).paginate(page: params[:page], per_page: @per_page).to_json
  end

  def create
    @service = NcService.new nc_service_params
    if @service.save
      flash[:notice] = "Domain name has been successfully saved"
    else
      flash[:alert] = "Failed to save domain name: " + @domain.errors.full_messages.join(", ")
    end
    redirect_to action: :index
  end

  def show
    @nc_service = NcService.find params[:id]
  end

  def update
    @nc_service = NcService.find params[:id]
    if @nc_service.update_attributes nc_service_params
      flash[:notice] = "Service details have been successsfully updated"
    else
      flash[:alert] = "Failed to save updates: " + @nc_service.errors.full_messages.join("; ")
    end
    redirect_to action: :show
  end

  private

  def nc_service_params
    params.require(:nc_service).permit(:nc_service_type_id, :username, :name, :new_status, comments_attributes: [:id, :user_id, :content])
  end

end
