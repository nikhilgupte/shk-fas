class Order < ActiveRecord::Base
  attr_accessor :product_name_or_code
  attr_protected :created_by_id

  belongs_to :user, :foreign_key => :created_by_id
  belongs_to :product

  named_scope :todays, :conditions => "created_at between now()::date and (now() + interval '1 day')::date", :order => 'created_at desc'
  named_scope :all, :order => 'created_at desc'

  validates_presence_of :product_id, :created_by_id
  validates_numericality_of :quantity
  validates_inclusion_of :quantity, :within => 0.1..100, :message => 'should be between 0.1 and 100'
end
