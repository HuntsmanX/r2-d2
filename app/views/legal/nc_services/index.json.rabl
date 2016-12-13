object false

child :@services => :items do
  extends 'legal/nc_services/_base'
end

node :pagination do
  {
    totalRecords: @services.total_entries
  }
end