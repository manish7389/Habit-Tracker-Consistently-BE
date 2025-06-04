class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    
  has_many :habits, dependent: :destroy

  validates :email, :first_name, :last_name, presence: true

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def self.ransackable_associations(auth_object = nil)
    ["habits"]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id email first_name last_name is_active created_at updated_at]
  end

end
