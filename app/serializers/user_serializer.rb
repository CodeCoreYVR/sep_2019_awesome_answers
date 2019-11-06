class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :first_name,
    :last_name,
    :full_name, # You can include custom methods to be serialized 
    :created_at,
    :updated_at
  )
end
