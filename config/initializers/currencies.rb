class Numeric
  %w(usd_in_inr eur_in_inr inr_in_usd inr_in_eur).each do |c|
    define_method c do
      Currency.send(c, self)
    end
  end
end

