class AbuseReportsController < ApplicationController
  
  authorize_resource
  
  def index
    @search = AbuseReport.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @abuse_reports = @search.result(distinct: true).order(processed: :asc, created_at: :desc).paginate(page: params[:page], per_page: @per_page)
  end
  
  def new
  end
  
  def update_abuse_report_form
    @report_type = AbuseReportType.find(params[:abuse_report_type_id]).underscored_name
    @abuse_report_form = (@report_type + '_form').classify.constantize.new
  end
  
  def create
    @abuse_report_form = (AbuseReportType.find(params[:abuse_report_type_id]).underscored_name + '_form').classify.constantize.new
    if @abuse_report_form.submit(params)
      flash[:notice] = 'Abuse report has been successfully submitted'
      redirect_to action: :index
    else
      flash.now[:alert] = 'Unable to submit abuse report: ' + @abuse_report_form.errors.full_messages.join('; ')
      render action: :new
    end
  end
  
  def edit
    @report_type = AbuseReport.find(params[:id]).abuse_report_type.underscored_name
    @abuse_report_form = (@report_type + '_form').classify.constantize.new params[:id]
  end
  
  def update
    @abuse_report_form = (AbuseReport.find(params[:id]).abuse_report_type.underscored_name + '_form').classify.constantize.new params[:id]
    if @abuse_report_form.submit(params)
      flash[:notice] = 'Abuse report has been successfully updated'
      redirect_to action: :index
    else
      flash.now[:alert] = 'Unable to update abuse report: ' + @abuse_report_form.errors.full_messages.join('; ')
      render action: :edit
    end
  end
  
  def approve
    @abuse_report = AbuseReport.find params[:id]
    @notification = if @abuse_report.update_attributes abuse_report_params
      { notice: 'Abuse report has been successfully approved' }
    else
      { alert: 'Failed to approve abuse report: ' + @abuse_report.errors.full_messages.join('; ') }
    end
  end
  
  private
  
  def abuse_report_params
    params.require(:abuse_report).permit(:id, :processed, :processed_by, report_assignments_attributes:
                                  [:id, :reportable_type, reportable_attributes: [:id, :new_status] ])
  end
  
end