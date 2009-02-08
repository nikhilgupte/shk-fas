class Currency < ActiveRecord::Base
  named_scope :all, :order => 'name'
  def self.inr_value(name)
    find_by_name(name).inr_value rescue nil
  end
end
