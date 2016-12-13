class AbuseReport < ActiveRecord::Base
  
  belongs_to :abuse_report_type
  
  has_many :report_assignments
  has_many :nc_users, through: :report_assignments, source: :reportable, source_type: 'NcUser'
  has_many :nc_services, through: :report_assignments, source: :reportable, source_type: 'NcService'
  
  has_one :spammer_info
  has_one :ddos_info
  has_one :private_email_info
  has_one :abuse_notes_info
  
  accepts_nested_attributes_for :spammer_info, :ddos_info, :private_email_info, :abuse_notes_info, :report_assignments
  
  scope :direct,   -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 1).uniq }
  scope :indirect, -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 2).uniq }
  
  def reportable_name
    # spammer, ddos
    return self.report_assignments.where(reportable_type: 'NcUser').direct.first.reportable.username if [1, 2].include?(self.abuse_report_type_id) 
    # private email
    return self.report_assignments.direct.first.reportable.name if self.abuse_report_type_id == 3
    # abuse notes
    count = self.report_assignments.direct.count
    count.to_s + ' domain'.pluralize(count)
  end
  
  def direct_user_assignments
    self.report_assignments.select { |a| a.reportable_type == 'NcUser' && a.report_assignment_type_id == 1 }
  end
  
  def indirect_user_assignments
    self.report_assignments.select { |a| a.reportable_type == 'NcUser' && a.report_assignment_type_id == 2 }
  end
  
  def direct_service_assignments
    self.report_assignments.select { |a| a.reportable_type == 'NcService' && a.report_assignment_type_id == 1 }
  end
  
  def indirect_service_assignments
    self.report_assignments.select { |a| a.reportable_type == 'NcService' && a.report_assignment_type_id == 2 }
  end
  
  def related_reports
    self.nc_users.map(&:abuse_reports).flatten.uniq
  end

	def additional_action
    self.abuse_notes_info.try(:action)
  end

	def abuse_reported_by
    self.abuse_notes_info.try(:reported_by)
  end

	def nc_users_direct_first_signed
    self.nc_users.try(:direct).try(:first).try(:signed_up_on).try(:strftime, "%d %B %Y")
  end

	def domains_under_attack
    self.nc_services.map(&:name).join(", ")
  end

end