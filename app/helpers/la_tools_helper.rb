module LaToolsHelper

  def cache(data)
    current_user.update_attributes(cache: data.to_json) ? flash[:notice] = "Data has been successfully cached" : flash[:alert] = "Something went wrong"
  end

  def get_cache
    JSON.parse(current_user.cache, symbolize_names: true)
  end

  # Parse the CSV file + replace firstanme and lastname with fullname
  def parse_domains_info(csv_file)
    csv = SmarterCSV.process(csv_file.tempfile, strip_chars_from_headers: /'/)
    csv.each do |hash|
      name = hash[:firstname] + " " + hash[:lastname]
      hash.except!(:firstname, :lastname).merge!({ fullname: name })
    end
  end

  def color(hash)
    return "red" if Spammer.find_by(username: hash[:username].try(:downcase))
    return "blue" if VipDomain.find_by(domain: hash[:domainname].try(:downcase))
    ""
  end

  def vip_domain?(domain)
    VipDomain.find_by(domain: domain.try(:downcase)) ? true : false
  end

  def spammer?(username)
    Spammer.find_by(username: username.try(:downcase)) ? true : false
  end

  def transform_dbl_array(array)
    domains = array.collect { |hash| hash[:domainname] if !vip_domain?(hash[:domainname]) && hash[:dbl] == "YES" || hash[:surbl] == "YES" }.compact
    Hash[:domains, domains]
  end

  def get_canned_reply(data)
    reply = nil
    # DBL/SURBL check with no cache -> no username
    if data[:dbl] && !data[:username]
      # VIP domain?
      if vip_domain?(data[:domainname])
        reply = CannedReply.find_by(name: "dbl_surbl/vip_domain")
      else
        reply = CannedReply.find_by(name: "dbl_surbl/to_client")
      end
    # DBL/SURBL check using cache
    elsif data[:domains]
      if spammer?(data[:username])
        reply = CannedReply.find_by(name: "dbl_surbl/to_spammer")
      else
        reply = CannedReply.find_by(name: "dbl_surbl/to_client")
      end
    end
    substitute_domains(reply, data)
  end

  def substitute_domains(reply, data)
    if data[:domainname]
      reply.body = reply.body.gsub("$domains$", data[:domainname])
    elsif data[:domains]
      reply.body = reply.body.gsub("$domains$", data[:domains].join("\n"))
    end
    reply
  end

end