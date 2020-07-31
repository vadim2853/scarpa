module Constraints
  class SocialNetworkCrawlers
    def self.matches?(request)
      request.env['HTTP_USER_AGENT'].downcase =~ /facebookexternalhit|facebook|facebot|linkedinbot|twitter|pinterest/i
    end
  end
end
