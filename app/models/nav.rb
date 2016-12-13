class Nav

  NAVS = [
    {
      name:       'Tools',
      url:        '#/tools',
      icon:       'fi-widget',
      navs_name:  'tools_navs',
      child_navs: [
        {
          name:   'Whois',
          url:    '#/tools/whois',
          icon:   'fa fa-fw fa-file-o'
        }, {
          name:   'Bulk Whois',
          url:    '#/tools/bulk_whois',
          icon:   'fa fa-fw fa-files-o'
        }, {
          name:   'Data Extractor',
          url:    '#/tools/data_extractor',
          icon:   'fa fa-fw fa-search'
        }, {
          name:   'Internal Domains',
          url:    '#/tools/internal_domains',
          icon:   'fa fa-fw fa-home',
          klass:  Tools::InternalDomain
        }, {
          name:   'Lists Compare Tool',
          url:    '#/tools/lists_diff',
          icon:   'fa fa-fw fa-list'
        }, {
          name:   'Bulk Dig',
          url:    '#/tools/bulk_dig',
          icon:   'fa fa-fw fa-terminal'
        }, {
          name:   'Email Verifier',
          url:    '#/tools/email_verifier',
          icon:   'fa fa-fw fa-envelope-o'
        }
      ]
    }, {
      name:       'Domains & General',
      url:        '#/domains-general',
      icon:       'fi-web',
      navs_name:  'domains_navs',
      child_navs: [
        {
          name:   'Compensation System',
          url:    '#/domains-general/compensation',
          icon:   'fa fa-fw fa-usd',
          klass:  Domains::Compensation
        }, {
          name:   'Compensation Stats',
          url:    '#/domains-general/compensation/stats',
          icon:   'fa fa-fw fa-bar-chart',
          klass:  Domains::Compensation::Statistic
        }, {
          name:   'Watched Domains',
          url:    '#/domains-general/watched',
          icon:   'fa fa-fw fa-binoculars',
          klass:  Domains::WatchedDomain
        }, {
          name:   'Maintenance Alerts',
          url:    '/alerts',
          icon:   'fa fa-fw fa-bullhorn',
          klass:  :maintenance_alert
        }
      ]
    }, {
      name:       'Legal & Abuse',
      url:        '#/legal',
      icon:       'fi-sheriff-badge',
      navs_name:  'legal_navs',
      child_navs: [
        {
          name:   'Hosting Abuse',
          url:    '#/legal/hosting_abuse',
          icon:   'fa fa-fw fa-server',
          klass:  Legal::HostingAbuse
        }, {
          name:   'Abuse Reports',
          url:    '/abuse_reports',
          icon:   'fa fa-fw',
          klass:  AbuseReport
        }, {
          name:   'Namecheap Users',
          url:    '/nc_users',
          icon:   'fa fa-fw',
          klass:  NcUser
        }, {
          name:   'Namecheap Domains',
          url:    '#/legal/nc_domains',
          icon:   'fa fa-fw',
          klass:  NcService
        }, {
          name:   'Private Emails',
          url:    '/private_emails',
          icon:   'fa fa-fw',
          klass:  NcService
        }, {
          name:   'Multi RBL',
          url:    '#/legal/rbls',
          icon:   'fa fa-fw',
          klass:  Legal::Rbl
        }, {
          name:   'DBL/SURBL Check',
          url:    '#/legal/dbl_surbl',
          icon:   'fa fa-fw',
          klass:  :la_tool
        }, {
          name:   'Bulk CURL',
          url:    '#/legal/bulk_curl',
          icon:   'fa fa-fw',
          klass:  :la_tool
        }, {
          name:   'Resource Abuse',
          url:    '/resource_abuse',
          icon:   'fa fa-fw',
          klass:  :la_tool
        }, {
          name:   'Process Spam',
          url:    '/spam',
          icon:   'fa fa-fw',
          klass:  :la_tool
        }, {
          name:   'Spam Reports',
          url:    '/spam_reports',
          icon:   'fa fa-fw',
          klass:  :la_tool
        }, {
          name:   'HTML PDFier',
          url:    '/html_pdfier',
          icon:   'fa fa-fw',
          klass:  :la_tool
        }, {
          name:   'PDFier',
          url:    '#/legal/pdfier',
          icon:   'fa fa-fw',
          klass:  Legal::PdfReport
        }
      ]
    }, {
      name:       'User Management',
      url:        '#/user_management',
      icon:       'fi-torsos-all',
      navs_name:  'user_management_navs',
      child_navs: [
        {
          name:   'Users',
          url:    '#/user_management/users',
          icon:   'fa fa-fw fa-user',
          klass:  User
        }, {
          name:   'Roles & Permissions',
          url:    '#/user_management/roles',
          icon:   'fa fa-fw fa-key',
          klass:  Role
        }
      ]
    }
  ]

  attr_accessor :child_navs, :navs_name, :klass, :auth, :json

  def self.accessible_by_as_json ability
    navs = accessible_by ability
    
    result = navs.each_with_object({}) do |nav, hash|
      hash[nav.navs_name] = nav.child_navs.map(&:json)
    end

    main_navs = []
    navs.each do |nav|
      main_navs << { divider: true }
      main_navs << nav.json
    end
    main_navs << { divider: true }

    result['main_navs'] = main_navs

    result
  end

  def self.accessible_by ability
    navs = all.each do |nav|
      nav.child_navs.delete_if { |child_nav| child_nav.klass && ability.cannot?(:index, child_nav.klass) }
    end

    navs.delete_if { |nav| nav.child_navs.blank? }
  end

  def self.all
    NAVS.map { |nav| self.new nav }
  end

  def initialize options
    @json       = options.slice :name, :url, :icon
    @auth       = options[:auth]
    @klass      = options[:klass]
    @child_navs = init_child_navs(options[:child_navs]) if options[:child_navs]
    @navs_name  = options[:navs_name]
  end

  def init_child_navs child_navs
    child_navs.map do |child|
      child[:auth] = @auth if child[:auth].nil?
      Nav.new child
    end
  end

end
