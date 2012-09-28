require 'spec_helper'

describe User do

  before do 
    @user = User.new(
      name:     "Example User", 
      email:    "user@example.com",
      password: "foobar", 
      password_confirmation: "foobar")
  end 

  subject { @user }

  # user.respond_to?(:name, etc.)
  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :remember_token }
  it { should respond_to :admin }
  it { should respond_to :microposts } # via has_many
  it { should respond_to :authenticate }
  it { should respond_to :feed }
  
  it { should be_valid } # user.valid?
  it { should_not be_admin } # user.admin? (default: false)

  describe "accessible attributes" do
    
    it "should not allow access to admin" do
      expect { User.new(admin: "1") }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                    foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email       = @user.dup # duplicates the subject
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "not_foobar" }
    it { should_not be_valid }
  end

  describe "when password_confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid } 
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "when valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "when invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("not_foobar") }
      
      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before { @user.save }

    it "should have a nonblank remember token" do
      subject.remember_token.should_not be_blank
    end 
  end

  describe "micropost associations" do
    before { @user.save }

    let!(:older_post) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_post) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "it should have the right microposts in the right order" do
      @user.microposts.should == [newer_post, older_post]
      # remember @user.microposts returns an array!
    end

    it "should destroy associated micropost" do
      microposts = @user.microposts
      @user.destroy

      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
        # micropost.id.nil? should evaluate to true!
      end
    end

    describe "status" do
      let(:user) { FactoryGirl.create(:user) }
      let(:unfollowed_post) { FactoryGirl.create(:micropost, user: user) }

      its(:feed) { should include(older_post) }
      its(:feed) { should include(newer_post) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end
end
