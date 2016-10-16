class Legal::NcDomainsController < Legal::NcServicesController
  respond_to :json

  def show
    @nc_service = NcService.find params[:id]
  end

  private
  def service_type_id
    1
  end
end
