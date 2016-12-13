class Legal::NcService < ActiveRecord::Base
  self.table_name = "nc_services"

  belongs_to :nc_user
  belongs_to :nc_service_type
  has_many :report_assignments, as: :reportable
  has_many :abuse_reports, through: :report_assignments
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :comments

  before_save do
    self.name = self.name.strip.downcase
    self.status_ids.uniq!
  end

  after_save do
    if self.nc_service_type.id == 1 && self.status_ids.include?(1)
      self.nc_user.new_status = Status.find_by(name: "Has VIP Domains").id
      self.nc_user.save
    end
  end

  scope :direct,   -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 1).uniq }
  scope :indirect, -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 2).uniq }

  def destroy
    super unless self.report_assignments.present? || self.comments.present? || self.status_ids.include?(ServiceStatus.find_by_name('VIP'))
  end

  def new_status
    self.status_ids.last
  end

  def new_status=(status_id)
    self.status_ids << status_id.to_i
  end

  def status_names
    self.status_ids.map { |id| ServiceStatus.find id }.map(&:name)
  end

  def username
    self.nc_user.try(:username)
  end

  def username=(username)
    self.nc_user = NcUser.find_or_create_by(username: username.strip.downcase)
  end

  def status_icons
    status_names.map { |name| status_icon(name) }.join(' ').html_safe if status_names.present?
  end

  private

  def status_icon(status_name)
    return ActionController::Base.helpers.content_tag(:i, '', class: 'fa fa-diamond action', title: status_name) if status_name == "VIP"
    return ActionController::Base.helpers.content_tag(:i, '', class: 'fa fa-fire action', title: status_name)    if status_name == "Abused out"
    return ActionController::Base.helpers.content_tag(:i, '', class: 'fi-skull action', title: status_name)      if status_name == "DDoS Related"
    return ActionController::Base.helpers.content_tag(:i, '', class: 'fi-trash action', title: status_name)      if status_name == "FreeDNS"
  end
end
