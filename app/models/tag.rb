class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :questions, through: :taggings

  validates :name, presence: true, uniqueness: {
                                    case_sensitive: false
                                    # The case_sensitive option will
                                    # make uniqueness validation
                                    # ignore case. For example, two
                                    # records with names "ARTS" and
                                    # "Arts" can't co-exist.
                                  }

    private

    def downcase_name 
      self.name&.downcase!
    end
end
