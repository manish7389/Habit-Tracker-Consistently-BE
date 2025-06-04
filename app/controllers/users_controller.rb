class UsersController < ApplicationController
  skip_before_action :authenticate_request

  def signup
    user = User.new(user_params)
    if user.save
      user.update(is_active: true)
      token, refresh_token = generate_tokens(user)
      render json: {user: ActiveModelSerializers::SerializableResource.new(user, each_serializer: UserSerializer), message: 'Signup successful', access_token: token, refresh_token: refresh_token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user.nil?
      return render json: { error: 'User not found' }, status: :unauthorized
    elsif !user.valid_password?(params[:password])
      return render json: { error: 'Incorrect password' }, status: :unauthorized
    end
  
    token, refresh_token = generate_tokens(user)
    render json: { 
      user: ActiveModelSerializers::SerializableResource.new(user, each_serializer: UserSerializer), 
      access_token: token, 
      refresh_token: refresh_token 
    }, status: :ok
  end  

  def forgot_password
    return render json: { error: 'Email not present' }, status: :bad_request if params[:email].blank?

    user = User.find_by(email: params[:email])
    return render json: { error: 'Email address not found. Please check and try again.' }, status: :not_found unless user

    reset_code = generate_code
    user.update(reset_password_token: reset_code, reset_password_sent_at: Time.current)
    UserMailer.forgot_password(user, reset_code).deliver_now
    render json: { reset_token: jwt_encode(user_id: user.id), code: reset_code}, status: :ok
  end

  def resend_code
    return render json: { error: 'Token not present' }, status: :bad_request if params[:token].blank?

    user = find_user_by_token(params[:token])
    return render json: { error: 'User not found' }, status: :not_found unless user
  
    reset_code = generate_code
    user.update(reset_password_token: reset_code, reset_password_sent_at: Time.current)
    UserMailer.forgot_password(user, reset_code).deliver_now
  
    render json: { message: 'A new reset code has been sent to your email.', reset_token: jwt_encode(user_id: user.id), code: reset_code }, status: :ok
  end

  def verify_reset_code
    return render json: { error: 'Token not present' }, status: :bad_request if params[:token].blank?
    return render json: { error: 'Reset code is required' }, status: :bad_request if params[:code].blank?
  
    user = find_user_by_token(params[:token])
    return render json: { error: 'User not found' }, status: :not_found unless user
  
    if user.reset_password_token == params[:code]
      if user.reset_password_sent_at < 10.minutes.ago
        return render json: { error: 'Reset code expired. Please request a new one.' }, status: :unprocessable_entity
      end
  
      render json: { message: 'Reset code verified successfully', reset_token: jwt_encode(user_id: user.id) }, status: :ok
    else
      render json: { error: 'Invalid reset code' }, status: :unprocessable_entity
    end
  end

  def reset_password
    byebug
    return render json: { error: 'Token not present' }, status: :bad_request if params[:token].blank?
    return render json: { error: 'New password is required' }, status: :bad_request if params[:password].blank?
    return invalid_request('Password and confirm password does not match') unless passwords_match?

    user = find_user_by_token(params[:token])
    return render_invalid_link unless user
    byebug
    if user.reset_password!(params[:password])
      render json: { status: 'Password reset successfully' }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end

  def find_user_by_token(token)
    decoded = jwt_decode(token)
    User.find_by(id: decoded[:user_id]) rescue nil
  end
  
  def passwords_match?
    params[:password] == params[:confirm_password]
  end

  def generate_tokens(user)
    token = jwt_encode(user_id: user.id)
    refresh_token = jwt_encode({ user_id: user.id }, 7.days.from_now)
    [token, refresh_token]
  end

  def generate_code
    SecureRandom.hex(4).upcase
  end
end
