class Legal::NcDomainsController < Legal::NcServicesController
  authorize_resource class: 'NcService'
  respond_to :json

  def index
    @search = NcService.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @services = @search.result(distinct: true).where(nc_service_type_id: service_type_id).paginate(page: params[:page], per_page: @per_page)
  end

  def create
    @service = NcService.new nc_service_params
    redirect_to action: :index if  @service.save
  end

  def show
    @nc_service = NcService.find params[:id]
  end

  private
  def service_type_id
    1
  end
end
