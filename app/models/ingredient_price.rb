class IngredientPrice < ActiveRecord::Base
  validates_numericality_of :price_in_inr, :price_in_usd, :price_in_eur, :greater_than_or_equal_to => 0.01, :allow_blank => true

  belongs_to :ingredient
  belongs_to :user

  delegate :code, :name, :to => :ingredient, :prefix => true

  attr_accessor :force

  def validate_on_create
    if !(price_in_eur || price_in_inr || price_in_usd)
      errors.add_to_base('Please enter the price in at least one currency')
    elsif force != 'true'
      if prev = ingredient.latest_price
        if self.price_in_inr
          diff = (prev.base_inr - self.price_in_inr).abs
          errors.add(:price_in_inr, 'varies over 10% from the historic values.') if diff*100.0/prev.base_inr > 10
        end
        if self.price_in_usd
          diff = (prev.base_usd - self.price_in_usd).abs
          errors.add(:price_in_usd, 'varies over 10% from the historic values.') if diff*100.0/prev.base_usd > 10
        end
       if self.price_in_eur
          diff = (prev.base_eur - self.price_in_eur).abs
          errors.add(:price_in_eur, 'varies over 10% from the historic values.') if diff*100.0/prev.base_eur > 10
        end
      end
    end
  end

  def inr
    (price_in_inr ? price_in_inr * (100.0 + ingredient.tax_rate.rate) : base_inr * (100.0 + ingredient.custom_duty.duty))/100
  end

  def usd() base_usd end

  def eur() base_eur end

  def base_inr
    value = begin
      if price_in_inr
        price_in_inr
      elsif price_in_usd
        price_in_usd.usd_in_inr
      elsif price_in_eur
        price_in_eur.eur_in_inr
      else
        nil
      end
    end
  end

  def base_eur() price_in_eur || base_inr/Currency.inr_value('EUR') end

  def base_usd() price_in_usd || base_inr/Currency.inr_value('USD') end

  class << self
    def export(since = Date.parse('1 Jan 2009'))
      headers = ["Ingredient Code", "Ingredient Name", "Price", "Date"]
      data = all(:conditions => ["ingredient_prices.created_at >= ?", since],
        :order => 'ingredients.code ASC, ingredient_prices.created_at DESC',
        :include => :ingredient).collect{|p| [p.ingredient.code, p.ingredient.name, p.inr.round(2), p.created_at.to_date] }
      [headers] + data
    end
  end
end
