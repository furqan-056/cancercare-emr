class Organization < ApplicationRecord
  has_one_attached :logo

  has_one :address, as: :addressable, dependent: :destroy
  has_many :users, dependent: :destroy

  accepts_nested_attributes_for :users, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :address, allow_destroy: true

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :organization_type, presence: true
  validates :phone_number, presence: true

  before_validation :set_temp_password_for_users

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email organization_type phone_number created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[address users]
  end

  private

  def set_temp_password_for_users
    users.each do |user|
      next unless user.new_record?
      next unless user.password.blank?

      temp_password = Devise.friendly_token.first(12)
      user.password = temp_password
      user.password_confirmation = temp_password
    end
  end
end
