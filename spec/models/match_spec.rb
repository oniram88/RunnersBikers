# == Schema Information
#
# Table name: matches
#
#  id            :integer          not null, primary key
#  challenged_id :integer
#  challenger_id :integer
#  status        :integer
#  points        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Match, type: :model do


  it "match only possible within range +-3 of rank" do

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


    expect(userTOP.rank).to be == 1
    expect(userBAD.rank).to be == 9
    expect(challenger.rank).to be == 5

    expect(build(:match, challenger: challenger, challenged: user1)).to be_valid
    expect(build(:match, challenger: challenger, challenged: user2)).to be_valid
    expect(build(:match, challenger: challenger, challenged: user3)).to be_valid
    expect(build(:match, challenger: challenger, challenged: user4)).to be_valid
    expect(build(:match, challenger: challenger, challenged: user5)).to be_valid
    expect(build(:match, challenger: challenger, challenged: user6)).to be_valid

    expect(build(:match, challenger: challenger, challenged: userTOP)).not_to be_valid
    expect(build(:match, challenger: challenger, challenged: userBAD)).not_to be_valid


  end

end
