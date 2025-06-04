class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :is_active, :created_at, :updated_at
end
