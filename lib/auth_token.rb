class AuthToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 1.hour.from_now.to_i)
    payload[:exp] = exp
    header = Base64.urlsafe_encode64({ alg: "HS256", typ: "JWT" }.to_json)
    payload_encoded = Base64.urlsafe_encode64(payload.to_json)
    signature = Base64.urlsafe_encode64(OpenSSL::HMAC.digest("SHA256", SECRET_KEY, "#{header}.#{payload_encoded}"))

    "#{header}.#{payload_encoded}.#{signature}"
  end

  def self.decode(token)
    header, payload_encoded, signature = token.split(".")
    expected_signature = Base64.urlsafe_encode64(OpenSSL::HMAC.digest("SHA256", SECRET_KEY, "#{header}.#{payload_encoded}"))

    return nil unless ActiveSupport::SecurityUtils.secure_compare(expected_signature, signature)

    payload = JSON.parse(Base64.urlsafe_decode64(payload_encoded), symbolize_names: true)
    return nil if Time.now.to_i > payload[:exp]

    payload
  end
end

