class MatchNotifierMailer < ApplicationMailer
  add_template_helper(EmailsHelpers)

  def base_subject
    "TORNEO NEXT CHALLENGE PER RUNNER"
  end

  def notify_creation(match, to: :challenged)
    @match = match
    @destinatario = to

    object = base_subject
    case to
      when :challenged
        object += ' – SEI STATO SFIDATO'
      when :challenger
        object += ' – CONFERMA LANCIO SFIDA'
    end

    mail(
      to: @match.send(to).email,
      subject: object, &:mjml
    )
  end

  def notify_approval_waiting(match, to: :challenged)
    @match = match
    @destinatario = to

    object = base_subject + " – CONCLUSIONE SFIDA #{@match.challenger.full_name} VS #{@match.challenged.full_name} CON DUE SESSIONI REGISTRATE"

    mail(
      to: @match.send(to).email,
      subject: object, &:mjml
    )
  end

  def notify_approve_disapprove(match, to: :challenged)
    @match = match
    @destinatario = to

    object = base_subject + " –  ESITO SFIDA #{@match.challenger.full_name} VS #{@match.challenged.full_name}"

    mail(
      to: @match.send(to).email,
      subject: object, &:mjml
    )
  end

  def notify_outdated(match, to: :challenged)
    @match = match
    @destinatario = to

    object = base_subject + " –  ESITO SFIDA #{@match.challenger.full_name} VS #{@match.challenged.full_name}"

    if @match.winner
      object += " CON UNA SOLA SESSIONE REGISTRATA"
    else
      object += "  CON NESSUNA SESSIONE REGISTRATA"
    end

    mail(
      to: @match.send(to).email,
      subject: object, &:mjml
    )
  end

  def notify_judge(match, judge)
    @match = match
    @judge = judge

    object = base_subject
    case match.status
      when 'wait'
        object += ' – COMUNICAZIONE NUOVA SFIDA'
      when 'approval_waiting'
        object += " – CONCLUSIONE SFIDA #{@match.challenger.full_name} VS #{@match.challenged.full_name} CON DUE SESSIONI REGISTRATE"
      when 'timeouted'
        object += " – CONCLUSIONE SFIDA #{@match.challenger.full_name} VS #{@match.challenged.full_name}"

        if @match.winner
          object += " CON UNA SOLA SESSIONE REGISTRATA"
        else
          object += " CON NESSUNA SESSIONE REGISTRATA"
        end

    end

    mail(to: judge.email, subject: object, &:mjml)
  end
end
