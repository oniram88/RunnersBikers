require 'rails_helper'

RSpec.describe User, type: :model do


  describe "can  match" do


    it "same_user" do
    user = create(:user)

    expect(user.machable(user)).to be_falsey
    end

    it "vs users"do
      userTOP = create(:user)
      create(:performance, distance: 10, user: userTOP)
      user1 = create(:user)
      create(:performance, distance: 9, user: user1)
      user2 = create(:user)
      create(:performance, distance: 8, user: user2)
      user3 = create(:user)
      create(:performance, distance: 7, user: user3)

      challenger = create(:user)
      create(:performance, distance: 6, user: challenger)

      user4 = create(:user)
      create(:performance, distance: 5, user: user4)
      user5 = create(:user)
      create(:performance, distance: 4, user: user5)
      user6 = create(:user)
      create(:performance, distance: 3, user: user6)
      userBAD = create(:user)
      create(:performance, distance: 2, user: userBAD)

      expect(challenger.machable(userTOP)).to be_falsey
      expect(challenger.machable(user1)).to be_truthy
      expect(challenger.machable(user2)).to be_truthy
      expect(challenger.machable(user3)).to be_truthy
      expect(challenger.machable(user4)).to be_truthy
      expect(challenger.machable(user5)).to be_truthy
      expect(challenger.machable(user6)).to be_truthy
      expect(challenger.machable(userBAD)).to be_falsey

    end

end


end
