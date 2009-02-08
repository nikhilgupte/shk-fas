class IngredientPrice < ActiveRecord::Base
  validates_numericality_of :price_in_inr, :price_in_usd, :price_in_eur, :greater_than_or_equal_to => 0, :allow_blank => true

  belongs_to :ingredient
  belongs_to :user

  def validate_on_create
    #errors.add_to_base('Please enter the price in at least one currency') if !(price_in_eur && price_in_usd && price_in_usd)
  end

  def inr
    (price_in_inr ? price_in_inr * (100.0 + ingredient.tax_rate.rate) : converted_to_inr * (100.0 + ingredient.custom_duty.duty))/100
  end

  def usd
    price_in_usd ? price_in_usd : converted_to_usd
  end

  def eur
    price_in_eur ? price_in_eur : converted_to_eur
  end

  private
  def converted_to_eur() converted_to_inr/Currency.inr_value('EUR') end
  def converted_to_usd() converted_to_inr/Currency.inr_value('USD') end

  def converted_to_inr
    value = begin
      if price_in_inr
        price_in_inr
      elsif price_in_usd
        price_in_usd * Currency.inr_value('USD')
      elsif price_in_eur
        price_in_eur * Currency.inr_value('EUR')
      else
        nil
      end
    end
  end
end
