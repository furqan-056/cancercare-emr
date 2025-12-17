class Organization < ApplicationRecord
  has_one_attached :logo
  has_one :address, as: :addressable, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :doctors, -> { where(type: 'Doctor') }, class_name: 'User'
  has_many :managers, -> { where(type: 'Manager') }, class_name: 'User'
  has_many :patients, -> { where(type: 'Patient') }, class_name: 'User'

  accepts_nested_attributes_for :users, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :address, allow_destroy: true

  validates :name, :organization_type, :phone_number, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug

  def self.ransackable_attributes(auth_object = nil)
    %w[name email organization_type phone_number]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[address users]
  end

  def set_slug
    self.slug ||= name.parameterize
  end
end
