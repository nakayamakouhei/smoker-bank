class ContactForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :email, :string
  attribute :message, :string, default: ""

  validates :name, presence: { message: "お名前を入力してください" }, length: { maximum: 100 }
  validates :email,
            presence: { message: "メールアドレスを入力してください" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "正しいメールアドレスを入力してください" }
  validates :message, length: { maximum: 2000 }

  def name=(value)
    super(value.to_s.strip)
  end

  def email=(value)
    super(value.to_s.strip)
  end
end
