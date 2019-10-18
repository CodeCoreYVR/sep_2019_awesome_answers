class User < ApplicationRecord
    validates :email, presence: true
    has_secure_password
    has_many :questions, dependent: :nullify
    has_many :answers, dependent: :nullify

    def full_name
        "#{first_name} #{last_name}".strip
    end
end
