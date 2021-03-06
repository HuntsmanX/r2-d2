class Domains::Compensation::Form

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :submitted_by_id,        Integer
  attribute :checked_by_id,          Integer
  attribute :status,                 String
  attribute :reference_id,           String
  attribute :reference_item,         String
  attribute :product_id,             Integer
  attribute :product_compensated_id, Integer
  attribute :service_compensated_id, Integer
  attribute :hosting_type_id,        Integer
  attribute :issue_level_id,         Integer
  attribute :compensation_type_id,   Integer
  attribute :discount_recurring,     Boolean
  attribute :compensation_amount,    Float
  attribute :tier_pricing_id,        Integer
  attribute :client_satisfied,       Boolean
  attribute :comments,               String
  attribute :qa_comments,            String
  attribute :used_correctly,         Boolean
  attribute :delivered,              Boolean

  validates :reference_id,           presence: true
  validates :service_compensated_id, presence: true,     if: :service_compensated_required?
  validates :compensation_amount,    presence: true,     if: :compensation_amount_required?
  validates :compensation_amount,    numericality: true, if: :compensation_amount_required?
  validates :tier_pricing_id,        presence: true,     if: :tier_pricing_required?

  def initialize compensation_id = nil
    @compensation = if compensation_id.present?
      Domains::Compensation.find compensation_id
    else
      Domains::Compensation.new
    end
  end

  def service_compensated_required?
    ![7, 8, 10].include?(product_compensated_id)
  end

  def compensation_amount_required?
    compensation_type_id != 7
  end

  def tier_pricing_required?
    compensation_type_id == 7
  end

  def model
    @compensation
  end

  def submit params
    self.attributes = params
    format_attributes
    return false unless valid?
    persist!
    true
  end

  private

  def persist!
    @compensation.assign_attributes attributes
    @compensation.save!
  end

  def format_attributes
    format_compensation_amount
  end

  def format_compensation_amount
    if compensation_amount.present? && compensation_amount.is_a?(String)
      self.compensation_amount = compensation_amount.gsub(',', '.')
    end
  end

end
