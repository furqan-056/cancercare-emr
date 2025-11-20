class AdminSubdomainConstraint
  def self.matches?(request)
    request.host == "admin.localhost" || request.subdomain == "admin"
  end
end
