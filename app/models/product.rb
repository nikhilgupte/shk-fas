require 'dbi'
class Product < ActiveRecord::Base

  validates_presence_of :name, :code
  validates_uniqueness_of :code, :allow_blank => true
  validates_numericality_of :quarterly_sales_quantity

  before_validation :fix_fields

  named_scope :live

  def long_name
    "#{code} - #{name}"
  end

  # Synchronizes products from the Business DB (EDPSQL/Business)
  def self.sync
    begin
      dbh = DBI.connect("dbi:ODBC:#{AppConfig.fas_mssql_db_dsn}", AppConfig.fas_mssql_db_username, AppConfig.fas_mssql_db_password)
      products = dbh.execute('exec fas_products')
      products.fetch_hash do |s_product|
        begin
          if product = find_by_code(s_product['prod_cd'])
            product.update_attributes :name => s_product['prod_desc'], :quarterly_sales_quantity => s_product['Sales_Qty']
          else
            Product.create! :code => s_product['prod_cd'], :name => s_product['prod_desc'], :quarterly_sales_quantity => s_product['Sales_Qty']
          end
        rescue
          logger.error("Error while syncing products: #{s_product['prod_cd']}/#{s_product['prod_desc']}/#{s_product['Sales_Qty']} - #{$!}")
        end
      end
    rescue
      logger.error("Error while syncing products - #{$!}")
    end
  end

  def self.find_by_code(code)
    find(:first, :conditions => ['lower(code) = ?', code.downcase])
  end

  private
  def fix_fields
    self.code = code.upcase.strip rescue nil
    self.production_code = production_code.upcase.strip rescue nil
    self.name = name.upcase.strip rescue nil
  end
end
