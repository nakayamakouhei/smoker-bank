require "sendgrid-ruby"

class SendgridMailer
  include SendGrid

  # ---------------------------------------------------------
  # 汎用メール送信（共通ロジック）
  # ---------------------------------------------------------
  def self.send_email(to:, subject:, body:, from: "paradinatu@gmail.com")
    mail = Mail.new(
      Email.new(email: from),
      subject,
      Email.new(email: to),
      Content.new(type: "text/plain", value: body)
    )

    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
    response = sg.client.mail._("send").post(request_body: mail.to_json)

    Rails.logger.info "SendGrid Response (#{subject}): #{response.status_code}"
    response
  rescue => e
    Rails.logger.error "SendGrid Error: #{e.message}"
  end

  # ---------------------------------------------------------
  # お問い合わせ（管理者宛）
  # ---------------------------------------------------------
  def self.contact_admin(name, email, message)
    body = <<~TEXT
      名前: #{name}
      メール: #{email}
      内容:
      #{message}
    TEXT

    send_email(
      to: "paradinatu@gmail.com",
      subject: "【Smoker Bank】お問い合わせが届きました",
      body: body
    )
  end

  # ---------------------------------------------------------
  # お問い合わせ（ユーザー宛）
  # ---------------------------------------------------------
  def self.contact_user(name, email)
    body = <<~TEXT
      #{name} 様

      お問い合わせありがとうございます。
      内容を確認の上、必要に応じてご連絡いたします。

      ───────────────
      Smoker Bank 運営チーム
    TEXT

    send_email(
      to: email,
      subject: "【Smoker Bank】お問い合わせありがとうございます",
      body: body
    )
  end

  # ---------------------------------------------------------
  # パスワードリセット（Devise用）
  # ---------------------------------------------------------
  def self.password_reset(email, reset_link)
    body = <<~TEXT
      #{email} 様

      以下のリンクからパスワードの再設定を行ってください：

      #{reset_link}

      ※このリンクの有効期限は一定時間です。期限切れの場合は再度お試しください。
    TEXT

    send_email(
      to: email,
      subject: "【Smoker Bank】パスワード再設定のご案内",
      body: body
    )
  end
end
