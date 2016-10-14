attributes :id, :nc_user_id, :nc_service_type_id, :status_ids, :name

node(:created_at_formatted) do |d|
  d.created_at.strftime '%b/%d/%Y, %H:%M'
end

node(:nc_user_id,            if: -> (h) { h.nc_user_id })   { |h| h.nc_user.username }

node(:nc_service_type_id,    if: -> (h) { h.nc_user_id })   { |h| h.abuse_reports.direct.count }

node(:status_ids,            if: -> (h) { h.status_ids })   { |h| h.status_icons.html_safe }

node(:updated_at_formatted) do |d|
  d.updated_at.strftime '%b/%d/%Y, %H:%M'
end