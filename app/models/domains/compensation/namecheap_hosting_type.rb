class Domains::Compensation::NamecheapHostingType < ActiveRecord::Base
  self.table_name = 'domains_nc_hosting_types'

  has_many :services, class_name: 'Domains::Compenstion::NamecheapService', foreign_key: 'hosting_type_id'
end
