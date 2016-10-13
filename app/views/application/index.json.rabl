object false

node :environment do
  Rails.env
end

node :current_user do
  current_user.as_json(only: [:id, :name, :email])
end

node :current_ability do
  current_ability.as_json
end

node :entities do
  {
    legal: {
      hosting_abuse: {
        ddos: {
          block_type: Legal::HostingAbuse::Ddos::BlockType.all.as_json(only: [:id, :name])
        },
        resource: {
          abuse_type:    Legal::HostingAbuse::Resource::AbuseType.all.as_json(only: [:id, :name]),
          impact:        Legal::HostingAbuse::Resource::Impact.all.as_json(only: [:id, :name]),
          type:          Legal::HostingAbuse::Resource::ResourceType.all.as_json(only: [:id, :name]),
          upgrade:       Legal::HostingAbuse::Resource::Upgrade.all.as_json(only: [:id, :name]),
          activity_type: Legal::HostingAbuse::Resource::ActivityType.all.as_json(only: [:id, :name]),
          measure:       Legal::HostingAbuse::Resource::Measure.all.as_json(only: [:id, :name])
        },
        spam: {
          detection_method: Legal::HostingAbuse::Spam::DetectionMethod.all.as_json(only: [:id, :name]),
          queue_type:       Legal::HostingAbuse::Spam::QueueType.all.as_json(only: [:id, :name]),
          pe_queue_type:    Legal::HostingAbuse::Spam::PeQueueType.all.as_json(only: [:id, :name]),
          content_type:     Legal::HostingAbuse::Spam::ContentType.all.as_json(only: [:id, :name]),
          pe_content_type:  Legal::HostingAbuse::Spam::PeContentType.all.as_json(only: [:id, :name]),
          reporting_party:  Legal::HostingAbuse::Spam::ReportingParty.all.as_json(only: [:id, :name])
        },
        other: {
          abuse_type: Legal::HostingAbuse::Other::AbuseType.all.as_json(only: [:id, :name])
        },
        service:         Legal::HostingAbuse::Service.all.as_json(only: [:id, :name, :properties]),
        type:            Legal::HostingAbuse::AbuseType.all.as_json(only: [:id, :name]),
        management_type: Legal::HostingAbuse::ManagementType.all.as_json(only: [:id, :name]),
        reseller_plan:   Legal::HostingAbuse::ResellerPlan.all.as_json(only: [:id, :name]),
        shared_plan:     Legal::HostingAbuse::SharedPlan.all.as_json(only: [:id, :name]),
        vps_plan:        Legal::HostingAbuse::VpsPlan.all.as_json(only: [:id, :name]),
        suggestion:      Legal::HostingAbuse::Suggestion.all.as_json(only: [:id, :name]),

        reported_by:     Legal::HostingAbuse.reported_by.as_json(only: [:id, :name]),
        processed_by:    Legal::HostingAbuse.processed_by.as_json(only: [:id, :name])
      },
      rbl_status:     Legal::RblStatus.all.as_json(only: [:id, :name]),
      service_status: ServiceStatus.all.as_json(only: [:id, :name])
    },
    domains: {
      compensation: {
        product:           Domains::Compensation::NamecheapProduct.all.as_json(only: [:id, :name]),
        hosting_type:      Domains::Compensation::NamecheapHostingType.all.as_json(only: [:id, :name]),
        issue_level:       Domains::Compensation::IssueLevel.all.as_json(only: [:id, :name]),
        compensation_type: Domains::Compensation::CompensationType.all.as_json(only: [:id, :name]),
        tier_pricing:      Domains::Compensation::TierPricing.all.as_json(only: [:id, :name]),
        submitted_by:      Domains::Compensation.submitted_by.as_json(only: [:id, :name])
      }
    },
    navs:                 Nav.accessible_by_as_json(current_ability),
    directory_groups:     DirectoryGroup.order(:name).as_json(only: [:id, :name]),
    roles:                Role.order(:name).as_json(only: [:id, :name]),
    ability_resources:    Ability::Resource.all.map do |resource|
      {
        description:     resource.description,
        permissions:     resource.permissions.map do |permission|
          {
            identifier:  permission.identifier,
            description: permission.description
          }
        end
      }
    end
  }
end
