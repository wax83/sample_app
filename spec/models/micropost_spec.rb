# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Micropost do
  
  let(:user) { FactoryGirl.create(:user) }

  before do
    @micropost = user.microposts.build(content: "Lorem ipsum")
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) } # via belongs_to
  its(:user) { should == user } # @micropost.user == user

  it { should be_valid }

  describe "when user id is not present" do
    before { @micropost.user_id = nil }

    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect { Micropost.new(user_id: "1") }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  # Validations
  describe "with blank content" do
    before { @micropost.content = '' }
    it { should_not be_valid }
  end

  describe "with too long content" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end
