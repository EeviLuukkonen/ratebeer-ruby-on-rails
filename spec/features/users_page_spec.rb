require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create :user
    @user2 = FactoryBot.create :user, username: "Kalle", password: "Password1", password_confirmation: "Password1"
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has signed in" do
    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
    end

    describe "and has ratings" do
      before :each do
        FactoryBot.create(:rating, score: 10, user: @user)
        FactoryBot.create(:rating, score: 20, user: @user)
        visit user_path(@user)
      end

      it "can see their own ratings on their page" do
        save_and_open_page
        expect(page).to have_content 'anonymous 10'
        expect(page).to have_content 'Has made 2 ratings with average of 15.0'
      end

      it "can not see other users' ratings" do
        FactoryBot.create(:rating, score: 30, user: @user2)

        expect(page).not_to have_content 'anonymous 30'
        expect(page).to have_content 'Has made 2 ratings'
      end

      it "can delete their own rating" do
        expect {
          all('a', text: 'Delete')[0].click
        }.to change{Rating.count}.from(2).to(1)
        
        save_and_open_page
        expect(page).not_to have_content 'anonymous 10'
      end

      it "can see their favorite style and brewery" do
        expect(page).to have_content 'Favourite style: Lager'
        expect(page).to have_content 'Favourite brewery: anonymous'
      end
    end
  end
end