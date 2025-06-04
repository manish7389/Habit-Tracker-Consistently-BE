ActiveAdmin.register User do

  permit_params :email, :first_name, :last_name, :is_active

  filter :email
  filter :first_name
  filter :last_name
  filter :is_active
  filter :created_at

  config.filters = true

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :is_active
    column :created_at
    actions
  end
  
end
