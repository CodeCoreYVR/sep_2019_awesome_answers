class Question < ApplicationRecord
  has_many(:answers, dependent: :destroy)
  belongs_to :user
  # belongs_to :user adds a presence validation on the
  # association. i.e.
  # validates :user_id, presence: true
  
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
