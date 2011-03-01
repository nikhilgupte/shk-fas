class Formulation < ActiveRecord::Base

  validates_uniqueness_of :code, :case_sensitive => false

  def name_with_code
    "#{name} (#{code})"
  end

  class << self
    def find_by_code(code)
      first(:conditions => ["lower(code) = ?", code.downcase])
    end
  end
end
