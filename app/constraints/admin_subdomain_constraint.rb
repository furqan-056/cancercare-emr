class AdminSubdomainConstraint
  def self.matches?(request)
    host = request.host
    host == "admin.localhost" || request.subdomain == "admin"
  end
end
