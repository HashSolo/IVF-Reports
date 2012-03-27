class Request < ActiveRecord::Base
  belongs_to :clinic
  belongs_to :user
  
  default_scope :order => 'created_at DESC'
  
  
  #can add a method that calculates the price
  
  def paypal_encrypted(return_url, notify_url)
    user = User.find_by_id(user_id)
    
    values = {
      :business => "info@ivfreports.org",
      :lc => 'US',
      :cmd => '_xclick',
      :item_name => "Patient Lead: #{user.name}",
      :item_number => id,
      :invoice => id,
      :amount => 10.00,
      :currency_code => 'USD',
      :notify_url => notify_url,
      :rm => 1,
      :return => return_url,
      :cert_id => '6RRSVX4ACHKP2'
    }
    
    "https://www.paypal.com/cgi-bin/webscr?" + values.to_query
    
  end
  
  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert.pem")
  APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
  APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end
  
end
