class Legal::NcServicesController < ApplicationController
  authorize_resource class: 'NcService'
  respond_to :json

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
