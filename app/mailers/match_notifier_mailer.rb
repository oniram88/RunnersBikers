class MatchNotifierMailer < ApplicationMailer
  def notify_creation(match)
    @match = match
    mail(
      to: @match.challenged.email,
      subject: 'TORNEO NEXT CHALLENGE PER RUNNER – SEI STATO SFIDATO', &:mjml
    )
  end

  def notify_approve_disapprove(match, to: :challenged)
    @match = match
    mail(
      to: @match.send(to).email,
      subject: 'Esito Match', &:mjml
    )
  end

  def notify_outdated(match, to: :challenged)
    @match = match
    mail(
      to: @match.send(to).email,
      subject: 'Sfida Scaduta', &:mjml
    )
  end

  def notify_judge(match, judge)
    @match = match
    mail(to: judge.email, subject: "Sfida #{@match.challenged} VS #{@match.challenger}", &:mjml)
  end
end
