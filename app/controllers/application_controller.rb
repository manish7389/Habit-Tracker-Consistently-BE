class ApplicationController < ActionController::Base
  include JsonWebToken

  skip_before_action :verify_authenticity_token
  before_action :authenticate_request, unless: :admin_path?

  private

  attr_reader :current_user

  def set_url_options
    ActiveStorage::Current.url_options = { host: "https://#{ENV["HOST"]}" }
  end

  def authenticate_request
    token = request.headers[:Token]&.split(" ")&.last
    if token.present?
      decoded = jwt_decode(token)
      return render json: { message: "Token Expired" }, status: :unauthorized if decoded == :expired
      return render json: { message: "Unauthorized User" }, status: :unauthorized unless decoded

      @current_user = User.find_by(id: decoded[:user_id])
      render json: { message: "Unauthorized User" }, status: :unauthorized unless @current_user
    else
      render json: { message: "Unauthorized User" }, status: :unauthorized unless @current_user
    end
  end

  def admin_path?
    request.path.match?(%r{^/(en|ja)/admin}) || request.path.match?(%r{^/admin})
  end
  
end
