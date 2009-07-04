class BillOfMaterials < ActiveRecord::Base

  has_many :items, :class_name => 'BillOfMaterialsItems', :order => :id
  belongs_to :production_plan
  belongs_to :created_by, :class_name => "User"

  validates_presence_of :items, :message => ' are required'
  validates_length_of :remarks, :maximum => 255
end
