class OrganizationSubdomainConstraint
  def self.matches?(request)
    request.subdomain.present? && !%w[www admin].include?(request.subdomain)
  end
end
