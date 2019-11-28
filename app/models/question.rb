class Question < ApplicationRecord
  has_many(:answers, dependent: :destroy)
  belongs_to :user
  # belongs_to :user adds a presence validation on the
  # association. i.e.
  # validates :user_id, presence: true
  has_many :likes, dependent: :destroy
  # The `has_many` below depends on the existence of
  # `has_many :likes` above.
  # If the one above doesn't exist, you will get an error. (Or
  # if the one above comes after).
  has_many :likers, through: :likes, source: :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings#, source: :tag
  # If the name of the association (i.e. tags) is the same as the
  # source singularized (i.e. tag), then the `source:` named
  # argument can be omitted.
  #  We don't actually need to add an image field to the model with
  # Active Storage
  has_one_attached :image


  # This is the  Question model
  # We generated this file with the command:
  # rails g model question title:string body:text
  # This command also generates a migration file
  # in db/migrate

  # Rauls will add attr_accessors for all columns of
  # the database table. (i.e. id, title, body, created_at, updated_at)

  # Create validations by using the 'validates' method
  # The arguments are (in order):
  # - A column name as a symbol
  #  - Named arguments corresponding to the
  # validation rules you want to set.

  validates(:title, presence: true, uniqueness: true)
  # presence refuses any record with the column nil
  # or empty

  validates :body,
            presence: { message: "must exist"}, length: { minimum: 10 }

  validates :view_count,
            numericality:
              { greater_than_or_equal_to: 0 }

  # When a validation fails, ActiveRecord will not
  # save the model instance or any changes to the db.
  # You can view validation errors, by calling
  # the .errors method on the object itself.

  # To list them in a human friendly manner:
  # q.errors.full_messages

  # Custom validation
  # Be careful, the method for custom validations is
  # singular, otherwise it's almost exactly the same
  # as for regular validations.
  validate :no_monkey

  # before_validation is a lifecycle callback method
  # that allows us to respond to events during the
  # life of a model instance (i.e. being vaidated, being created, being updated etc.)

  before_validation :set_default_view_count

  # scopes
  # Create a scope with a class method
  # def self.most_recent(limit)
  #   order(created_at: :desc).limit(limit)
  # end
  # Scopes are such a commonly used feature, that
  # there's a way to create them quicker.
  # It takes a scope name and a lambda as a callback

  scope :most_recent, -> (limit) { order(created_at: :desc).limit(limit) }

  scope :search, -> (query) {
    where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%")
  }
  # equivalent to:
  # def self.search(query)
  #   where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%")
  # end

  scope :viewable, -> {
    where(aasm_state: [:published, :answered, :not_answered])
  }


  include AASM

  aasm whiny_transitions: false do
    state :draft, initial: true
    state :published
    state :featured
    state :answered
    state :not_answered
    state :archived

    event :publish do
      transitions from: :draft, to: :published
    end

    event :answer do
        transitions from: [:not_answered, :published], to: :answered
    end

    event :no_answer do
      transitions from: :published, to: :not_answered
    end

    event :archive do
      transitions to: :archived
    end
  end

  def tag_names
    self.tags.map(&:name).join(", ")
    # The & symbol is used to tell Ruby that the following argument
    # should be treated as a block given to the method. So the line:
    # self.tags.map(&:name).join(", ")
    # is equivalent to:
    # self.tags.map { |x| x.name }.join(", ")
    # So the above will iterate over the collection self.tags
    # and build an array with the result of the name method
    # called on every item. (We then join the array into a comma
    # separated string)
  end

  # Appending = at the end of a method name, allows us to implement
  # a `setter`. A setter is a method that is assignable.
  # Example:
  # q.tag_names = "stuff, yo"

  # The code in the example above would call the method we wrote
  # below where the value on the right hand side of the `=` would
  # become the argument to the method.

  # This is similar to implementing an `attr_writer`
  def tag_names=(rhs)
    self.tags = rhs.strip.split(/\s*,\s*/).map do |tag_name|
      # Finds the first record with the given attributes, or
      # initializes a record (Tag.new) with the attributes
      # if one is not found.
      Tag.find_or_initialize_by(name: tag_name)
      # If a tag with name tag_name is not found,
      # it will call Tag.new(name: tag_name)
    end
  end

  private

  def no_monkey
    # &. is the safe navigation operator. It's used
    # like the `.` iperator to call methods on an
    # object. If the method doesn't exist for an
    # object `nil` will be returned instead of
    # getting an error
    if body&.downcase&.include?("monkey")
      # To make a record invalid, you must add a
      # validation error, using the errors `add`
      # method. Its arguments are (in order):
      # - A symbol for the invalid column
      # - An error message as a string.
      self.errors.add(:body, "must not have monkeys")
    end
  end

  def set_default_view_count
    # If you are writing to an attribute accessor,
    # you must prefix with self. which you do not
    # have to do if you are just reading it insead
    self.view_count ||= 0
    # self.view_count || self.view_count = 0
  end

end
