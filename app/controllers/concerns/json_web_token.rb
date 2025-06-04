require "jwt"
module JsonWebToken
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secret_key_base

  def jwt_encode(payload, exp = nil)
    exp ||= 30.day.from_now #need to change the expiery. Currently made this change for Development
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    rescue JWT::ExpiredSignature
      :expired
    rescue
      false
    end
  end
end