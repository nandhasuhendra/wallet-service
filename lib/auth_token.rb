class AuthToken
  def initialize
    @key = Rails.application.credentials.encryption_key
    @openssl = OpenSSL::Cipher.new("aes-256-cbc")
  end

  def encode(payload)
    payload[:exp] = 24.hours.from_now.to_i
    @openssl.encrypt
    @openssl.key = @key
    @openssl.iv = iv = @openssl.random_iv
    encrypted = @openssl.update(payload.to_json) + @openssl.final
    Base64.encode64(iv + encrypted)
  end

  def decode(token)
    data = Base64.decode64(token)
    @openssl.decrypt
    @openssl.key = @key
    @openssl.iv = data.slice!(0, 16)

    result = JSON.parse(@openssl.update(data) + @openssl.final)
    return nil if result["exp"] < Time.now.to_i

    result
  end
end
