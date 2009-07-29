class ExportLog < ActiveRecord::Base
  belongs_to :user
  named_scope :all, :order => 'created_at DESC'
end
