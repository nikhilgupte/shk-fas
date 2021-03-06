class Currency < ActiveRecord::Base
  validates_numericality_of :inr_value, :greater_than_or_equal_to => 0

  named_scope :all, :order => 'name'

  def self.inr_value(name)
    find_by_name(name).inr_value rescue nil
  end

  def self.usd_in_inr(value) value * inr_value('USD') end

  def self.eur_in_inr(value) value * inr_value('EUR') end

  def self.inr_in_usd(value) value / inr_value('USD') end

  def self.inr_in_eur(value) value / inr_value('EUR') end

end

