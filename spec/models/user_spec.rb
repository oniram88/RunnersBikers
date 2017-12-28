# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  api_token              :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  image                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  rank                   :integer
#  total_points           :integer          default(0)
#  username               :string(255)
#

require 'rails_helper'

RSpec.describe User, type: :model do


  describe "can  match" do


    it "same_user" do
      user = create(:user)

      expect(user.machable(user)).to be_falsey
    end

    it "vs users" do
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

    it "user with active match" do

      m = create(:match)

      expect(create(:performance).user.machable(m.challenger)).to be_falsey
      expect(create(:performance).user.machable(m.challenged)).to be_falsey

    end

    it "usesr with 3 challanged matches" do
      user = create(:user)

      RunnersBikers::MAX_AS_CHALLENGER.times do
        create(:completed_approved_match, challenger: user)
        user.reload
      end

      expect(create(:performance_with_points, points_set: user.total_points).user.machable(user)).to be_truthy
      expect(user.machable(create(:performance).user)).to be_falsey

    end

    it "user with3 challengered matches" do

      user = create(:user)

      RunnersBikers::MAX_AS_CHALLENGED.times do
        create(:completed_approved_match, challenged: user)
        user.reload
      end

      expect(create(:user).machable(user)).to be_falsey
      expect(user.machable(create(:performance_with_points, points_set: user.total_points).user)).to be_truthy

    end

    it "user with 0 points" do

      expect(create(:user).machable(create(:user))).to be_falsey
      expect(create(:performance).user.machable(create(:user))).to be_falsey
      expect(create(:user).machable(create(:performance).user)).to be_falsey
      expect(create(:performance).user.machable(create(:performance).user)).to be_truthy

    end

    it "user already matched"do

      m = create(:completed_approved_match)


      expect(m.challenger.machable(m.challenged)).to be_falsey
      expect(m.challenged.machable(m.challenger)).to be_truthy


    end

    it " too early for match "do

      Timecop.travel(RunnersBikers::TIME_TO_START_CHALLENGES-1.minute) do
        expect(create(:performance_with_points).user.machable(create(:performance_with_points).user)).to be_falsey
      end
      Timecop.travel(RunnersBikers::TIME_TO_START_CHALLENGES+1.second) do
        expect(create(:performance_with_points).user.machable(create(:performance_with_points).user)).to be_truthy
      end

    end


    it " too late for match "do

      Timecop.travel(RunnersBikers::MAX_TIME_FOR_START_CHALLENGES-1.minute) do
        expect(create(:performance_with_points).user.machable(create(:performance_with_points).user)).to be_truthy
      end
      Timecop.travel(RunnersBikers::MAX_TIME_FOR_START_CHALLENGES+1.second) do
        expect(create(:performance_with_points).user.machable(create(:performance_with_points).user)).to be_falsey
      end

    end

  end


end
