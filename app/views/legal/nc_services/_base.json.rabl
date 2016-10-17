attributes :id, :nc_user_id, :nc_service_type_id, :status_ids, :name

node(:created_at_formatted) do |d|
  d.created_at.strftime '%b/%d/%Y, %H:%M'
end

node(:nc_user_id,            if: -> (h) { h.nc_user_id })   { |h| h.nc_user.username }

node(:nc_service_type_id,    if: -> (h) { h.nc_user_id })   { |h| h.abuse_reports.direct.count }

node(:status_ids,            if: -> (h) { h.status_ids })   { |h| h.status_names }

child(:abuse_reports) do
  attributes :id, :abuse_report_type_id, :reported_by, :processed_by, :comment, :created_at, :processed, :nc_services, :additional_action, :abuse_reported_by, :nc_users_direct_first_signed, :domains_under_attack
  node(:abuse_report_type_id)  { |h| h.abuse_report_type.try(:name) }

  node(:reported_by)           { |h| User.find(h.reported_by).name }

  node(:created_at) do |d|
    d.created_at.strftime '%b %d %Y, %H:%M'
  end

  node(:nc_services) do |d|
    d.nc_services.direct.map(&:name).join(', ')
  end

  child(:ddos_info) do
    attributes :target_service, :impact, :last_signed_in_on, :amount_spent, :registered_domains, :free_dns_domains, :random_domains, :cfc_status, :cfc_comment, :client_ticket_id, :vendor_ticket_id
  end
end