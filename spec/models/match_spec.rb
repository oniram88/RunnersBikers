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
#  winner_id       :integer
#  looser_id       :integer
#  note            :text(65535)
#

require 'rails_helper'

RSpec.describe Match, type: :model do

  include ActiveJob::TestHelper


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

  it 'max as chellanger' do
    user = create(:user)

    RunnersBikers::MAX_AS_CHALLENGER.times do
      create(:completed_approved_match, challenger: user)
      user.reload
    end

    expect(build(:match, challenger: user)).not_to be_valid

  end

  it 'max as chellanged' do
    user = create(:user)

    RunnersBikers::MAX_AS_CHALLENGED.times do
      create(:completed_approved_match, challenged: user)
      user.reload
    end

    expect(build(:match, challenged: user)).not_to be_valid


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

  it "quando viene eseguita più di una performance prima che il challenged completi il match" do

    m = create(:match)

    expect(m.challenged_performance).to be_nil
    expect(m.challenger_performance).to be_nil

    expect {
      create(:performance, user: m.challenger)
      m.reload
    }.to change(m, :challenger_performance)

    expect {
      create(:performance, user: m.challenger)
      m.reload
    }.not_to change(m, :challenger_performance)


  end

  it "quando viene eseguita più di una performance prima che il challenger completi il match" do

    m = create(:match)

    expect(m.challenged_performance).to be_nil
    expect(m.challenger_performance).to be_nil

    expect {
      create(:performance, user: m.challenged)
      m.reload
    }.to change(m, :challenged_performance)

    expect {
      create(:performance, user: m.challenged)
      m.reload
    }.not_to change(m, :challenged_performance)


  end

  it "approve" do
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
          expect {
            m.approve(create(:judge))
            m.reload
          }.to change(m, :winner).to(winner)
        }.to change(m, :looser).to(looser)
      }.to change(m, :status).from('approval_waiting').to('approved')
      winner.reload
    }.to change(winner, :total_points).by(m.points)
  end

  it "disapprove" do
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

    after(:each) do
      Timecop.return
    end

    describe "out of time" do

      it "nessuna performance" do

        expect(@match.outdated?).to be_falsey

        Timecop.freeze(Time.now + RunnersBikers::MATCH_DURATION + 1.second)

        expect {
          perform_enqueued_jobs do
            expect {
              expect(@match.outdated?).to be_truthy
              Match.check_timeouts
              @match.reload
            }.to change(@match, :status).from('wait').to('timeouted')
          end
        }.to change {
          ActionMailer::Base.deliveries.count
        }.by(3)

      end

      it "solo una performance dallo sfidante" do
        create(:performance, user: @sfidante)

        Timecop.freeze(Time.now + RunnersBikers::MATCH_DURATION + 1.second)


        expect {
          perform_enqueued_jobs do
            expect {
              expect {
                Match.check_timeouts
                @match.reload
              }.to change(@match, :status).from('wait').to('timeouted')
            }.to change(@match, :winner).to(@sfidante)
          end
        }.to change {
          ActionMailer::Base.deliveries.count
        }.by(3)
      end

      it "solo una performance dallo sfidato" do
        create(:performance, user: @sfidato)

        Timecop.freeze(Time.now + RunnersBikers::MATCH_DURATION + 1.second)

        expect {
          perform_enqueued_jobs do
            expect {
              expect {
                Match.check_timeouts
                @match.reload
              }.to change(@match, :status).from('wait').to('timeouted')
            }.to change(@match, :winner).to(@sfidato)
          end
        }.to change {
          ActionMailer::Base.deliveries.count
        }.by(3)
      end

    end

    it do
      expect(@match.expiration_date).to be == @inizio_sfida + RunnersBikers::MATCH_DURATION
    end

    it "emails di creazione" do

      #creo fuori gli utenti altrimenti mi segna il conteggio dell'invio emails
      # anche quelle di conferma degli utenti
      u1 = create(:user)
      u2 = create(:user)

      expect {
        perform_enqueued_jobs do
          create(:match, challenger: u1, challenged: u2)
        end
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(3) #2 utenti e arbitro

    end

    it "performances create, invio email agli arbitri per validare" do

      expect {
        perform_enqueued_jobs do
          create(:performance, user: @sfidante)
          create(:performance, user: @sfidato)

          em = ActionMailer::Base.deliveries.last
          expect(em.to).to include(@judge.email)
          expect(em.body.encoded).to match('appena conclusa una sfida')
        end
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(1)

    end

    it "performance validata" do

      m = create(:completed_match)

      expect(m).to be_approval_waiting

      expect {
        perform_enqueued_jobs do
          expect {
            @judge.approve(m)
          }.to change(m, :status).from('approval_waiting').to('approved')
        end
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(3) #una per giudice e le altre per i due challengers

    end

    it "performance non valida" do
      m = create(:completed_match)

      expect(m).to be_approval_waiting

      expect {
        perform_enqueued_jobs do
          expect {
            @judge.disapprove(m)
          }.to change(m, :status).from('approval_waiting').to('disapproved')
        end
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(3) #una per giudice e le altre per i due challengers

    end

    it "Performance non valida in quanto patta" do
      m = create(:match)

      create(:performance, user: m.challenged, distance: 10, pace: '4:00', positive_gain: 1)
      create(:performance, user: m.challenger, distance: 10, pace: '4:00', positive_gain: 1)
      m.reload
      expect {

        @judge.approve(m)

      }.to change(m, :status).from('approval_waiting').to('approved')
    end


  end

end
