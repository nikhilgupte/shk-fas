class Export < ActiveRecord::BaseWithoutTable
  column :from, :date
  column :to, :date

  validates_date :from, :before => Time.today.to_date
  validates_date :to, :after => Proc.new {|o| o.from - 1.day}

end
