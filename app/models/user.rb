class User < ApplicationRecord
    has_many :questions, dependent: :nullify
    has_many :answers, dependent: :nullify
    has_many :job_posts, dependent: :nullify
    has_many :likes, dependent: :destroy
    # If you were to use has_many :questions then you will have two
    # `has_many :questions` and one will override the other.
    # To fix this we can give the association a different name
    # and specify the source option so that Rails will be able
    # to figure out the other end of the association.
    # Note: `source:` has to match a belongs_to association in
    # the join model (`like` in this case).
    has_many :liked_questions, through: :likes, source: :question
    has_many :sent_gifts, class_name: "User", foreign_key: :sender_id, dependent: :nullify
    has_many :received_gifts, class_name: "User", foreign_key: :reciever_id, dependent: :nullify
    has_one_attached :image

    has_secure_password
    # Provides user authentication features on the model
    # it's called in. Requires a column named `password_digest`
    # and the gem `bcrypt`
     # - It will add two attribute accessors for `password`
    #   and `password_confirmation`
    # - It will add a presence validation for the `password`
    #   field.
    # - It will save passwords assigned to `password`
    #   using bcrypt to hash and store it in the
    #   the `password_digest` column meaning that we'll
    #   never store plain text passwords.
    # - It will add a method named `authenticate` to verify
    #   a user's password. If called with the correct password,
    #   it will return the user. Otherwise, it will return `false`
    # - The attr accesssor `password_confirmation` is optional.
    #   If it is present, a validation will verify that it is
    #   identical to the `password` accessor.
    validates :email, presence: true, uniqueness: true,
              format:  /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, unless: :from_oauth?

    geocoded_by :address
    after_validation :geocode

    def full_name
        "#{first_name} #{last_name}".strip
    end

    def self.create_from_oauth(oauth_data)
      names = oauth_data["info"]["name"]&.split || oauth_data["info"]["nickname"]

      # Create the user
      self.create(
        first_name: names[0],
        last_name: names[1] || "",
        uid: oauth_data["uid"],
        provider: oauth_data["provider"],
        oauth_raw_data: oauth_data,
        password: SecureRandom.hex(32)
      )
    end

    def self.find_from_oauth(oauth_data)
      self.find_by(
        uid: oauth_data["uid"],
        provider: oauth_data["provider"]
      )
    end

    serialize :oauth_raw_data

    private

    def from_oauth?
      uid.present? && provider.present?
    end
end
