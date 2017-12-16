# == Schema Information
#
# Table name: matches
#
#  id              :integer          not null, primary key
#  challenged_id   :integer
#  challenger_id   :integer
#  status          :integer
#  points          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  challenger_p_id :integer
#  challenged_p_id :integer
#  judge_id        :integer
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

  it "associazione automatica" do

    m = create(:match)

    expect(m.challenged_performance).to be_nil
    expect(m.challenger_performance).to be_nil

    expect {
      expect {
        create(:performance, user: m.challenger)
        m.reload
      }.to change(m, :challenger_performance)

      expect {
        create(:performance, user: m.challenged)
        m.reload
      }.to change(m, :challenged_performance)
    }.to change(m, :status).from("wait").to("approval_waiting")

  end

  it "approve"do
    m = create(:completed_match)

    if m.challenged_performance.points > m.challenger_performance.points
      winner = m.challenged
      looser = m.challenger
    else
      winner = m.challenger
      looser = m.challenged
    end

    expect {
      expect {
        expect {
          m.approve(create(:judge))
          m.reload
        }.to change(m, :winner).to(winner)
      }.to change(m, :looser).to(looser)
    }.to change(m, :status).from('approval_waiting').to('approved')

  end

  it "disapprove"do
    m = create(:completed_match)

    expect {
      m.disapprove(create(:judge))
      m.reload
    }.to change(m, :status).from('approval_waiting').to('disapproved')

  end

  describe "generazione emails e cambi status del match" do


    before(:each) do

      @judge = create(:judge)

      Timecop.freeze(Time.now)

      @match = create(:match)

      @inizio_sfida = @match.created_at

      @sfidante = @match.challenger
      @sfidato = @match.challenged


    end

    it do
      expect(@match.expiration_date).to be == @inizio_sfida + RunnersBikers::MATCH_DURATION
    end

    it "emails di creazione" do

      expect { create(:match) }
        .to change {
          ActionMailer::Base.deliveries.count
        }.by(2)

    end

    it "performances create, invio email agli arbitri per validare" do

      expect {
        create(:performance, user: @sfidante)
        create(:performance, user: @sfidato)

        em = ActionMailer::Base.deliveries.last
        expect(em.to).to include(@judge.email)
        expect(em.body.encoded).to match('Performance conclusa')
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(1)

    end

    it "performance validata" do

      m = create(:completed_match)

      expect(m).to be_approval_waiting

      expect {
        expect {
          @judge.approve(m)
        }.to change(m, :status).from('approval_waiting').to('approved')
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(3) #una per giudice e le altre per i due challengers

    end

    it "performance non valida" do
      m = create(:completed_match)

      expect(m).to be_approval_waiting

      expect {
        expect {
          @judge.disapprove(m)
        }.to change(m, :status).from('approval_waiting').to('disapproved')
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(3) #una per giudice e le altre per i due challengers

    end


  end

end
