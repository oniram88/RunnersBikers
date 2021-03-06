# == Schema Information
#
# Table name: performances
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  distance      :decimal(8, 4)
#  pace          :integer
#  positive_gain :integer
#  url           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  points        :decimal(15, 3)
#

require 'rails_helper'

RSpec.describe Performance, type: :model do


  it "after_create should update user_rank" do

    user1 = create(:user)
    create(:performance, distance: 10, user: user1)
    expect(user1.rank).to be == 1
    user2 = create(:user)
    expect(user2.rank).to be == 2

    expect {
      expect {
        expect {
          create(:performance, distance: 100, user: user2)
          user2.reload
          user1.reload
        }.to change(user2, :rank).from(2).to(1)
      }.to change(user1, :rank).from(1).to(2)
    }.to change(user2, :total_points)


  end

  #100 * (distance + positive_gain / 100) / (pace.to_f / 60)
  it "wil calculate correct values" do
    expect(build(:performance, distance: 100, positive_gain: 100, pace: 60).calculate_points).to be == 10100
  end

  it "oltre termine" do
    Timecop.freeze(RunnersBikers::MAX_ISCRIZIONE - 10.days) do
      @user = create(:user)
      Timecop.freeze(RunnersBikers::MAX_PERFORMANCE_INSERT) do
        expect(build(:performance, :user => @user)).not_to be_valid
      end
    end
  end

  it "on update change user points" do
    p = create(:performance)

    expect {
      p.update_attributes(:distance => p.distance + 1)
    }.to change(p.user, :total_points)

  end

  it "on destroy change user points" do
    p = create(:performance)

    expect {
      p.destroy
    }.to change(p.user, :total_points).by(p.points * -1)
  end


end
