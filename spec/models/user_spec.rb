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

  # User associations
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
  it { should respond_to :relationships }
  it { should respond_to :followed_users }
  it { should respond_to :reverse_relationships }
  it { should respond_to :followers }
  # Utility methods
  it { should respond_to :following? } 
  it { should respond_to :follow! }
  it { should respond_to :unfollow! }
  
  it { should be_valid } # user.valid?
  it { should_not be_admin } # user.admin? (default: false)

  describe "accessible attributes" do
    
    it "should not allow access to admin" do
      expect { User.new(admin: "1") }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "whith admin attribute set to 'true'" do
    before { @user.save && @user.toggle!(:admin) }

    it { should be_admin }
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
      
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times do
          followed_user.microposts.create!(content: "Lorem")
        end
      end

      its(:feed) { should include(older_post) }
      its(:feed) { should include(newer_post) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |mp|
          should include(mp)
        end
      end
    end
  end

  describe "following" do
    
    let(:other_user) {FactoryGirl.create(:user)}

    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) } 
    its(:followed_users) { should include(other_user) }

    describe "followed user" do # reverse relationship
      subject { other_user }

      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

end
