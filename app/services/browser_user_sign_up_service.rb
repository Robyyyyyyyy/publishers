class BrowserUserSignUpService < BaseService
  def initialize
  end

  def perform
    uphold_user = BrowserUser.create(role: Publisher::BROWSER_USER)
    Promo::Models::OwnerRegistration.create(
      publisher: uphold_user, 
      promo_campaign: PromoCampaign.find_by(name: PromoCampaign::PEER_TO_PEER).id,
      peer_to_peer: true
    )
    uphold_user
  end
end
