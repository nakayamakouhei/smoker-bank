Rails.application.config.x.webpush_vapid = {
  public_key:  ENV["VAPID_PUBLIC_KEY"],
  private_key: ENV["VAPID_PRIVATE_KEY"],
  subject: "mailto:info@example.com"
}
