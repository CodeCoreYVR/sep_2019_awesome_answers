require 'rails_helper'

# To generate this file after you have already created the model:
# rails g rspec:model job_post

# To run your tests with rspec, do:
# rspec
# (rspec <path to file>)

# To get more detailed information about the running tests, do:
# rspec -f d

# To get a list of all possible matchers for tests, go to:
# # https://relishapp.com/rspec/rspec-expectations/v/3-7/docs/built-in-matchers


RSpec.describe JobPost, type: :model do

  # The `describe` method is used to group like
  # tests together. It is primarily an organizational
  # tool. All of the grouped tests should be written
  # inside the block of the method.
  describe "#validates" do

    # `it` is another rspec keyword which is used to
    # define an `example` (test case). The string
    # argument is meant to descrive what specific
    # behaviour should happen inside of the `it` block
    it("requires a title") do
      # GIVEN
      # An instance of a JobPost without a title
      job_post = JobPost.new
      # WHEN
      # Validations are triggered
      job_post.valid?
      # THEN
      # There's an error related to the title
      # in the error object.
      expect(job_post.errors.messages).to(have_key(:title))
    end

    it 'requires a unique title' do
      # GIVEN
      # One job post in the db and an instance of job post
      # with the same title
      persisted_jp = FactoryBot.create(:job_post)
      jp = JobPost.new title: persisted_jp.title
      # WHEN
      # validations triggered
      jp.valid?
      # THEN
      # We get an error on title
      expect(jp.errors.messages).to(have_key(:title))
      expect(jp.errors.messages[:title]).to(include("has already been taken"))
    end

    it 'requires that min_salary is a number' do
      job_post = JobPost.new(min_salary: "one hundred")
      job_post.valid?
      expect(job_post.errors.messages).to have_key :min_salary
    end
  end

# As per Ruby docs, methods that are ddescribed with a `.` in front
# are class methods, while those described with a `#` in front are
# instance methods
  describe ".search" do

    it "should return job posts containing the search term" do
      # GIVEN
      # 3 job posts in the db
      job_post_a = FactoryBot.create(:job_post,
        title: "Software Engineer",
        description: "Best Job",
        min_salary: 40_000
      )
      job_post_b = FactoryBot.create(:job_post,
        title: "Awesome Programmer",
        description: "Best software",
        min_salary: 50_000
      )
      job_post_c = FactoryBot.create(:job_post,
        title: "Programmer",
        description: "Build awesome stuff",
        min_salary: 50_000
      )
      # WHEN
      # searching for 'software'
      results = JobPost.search("software")

      # THEN
      # JobPost A & B are returned
      expect(results).to eq([job_post_a, job_post_b])
    end

  end
end
