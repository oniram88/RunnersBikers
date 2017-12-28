module RunnersBikers

  VERSION = '1.0.2'

  # Durata Sfida
  MATCH_DURATION = 5.days

  # Tempo massimo inserimento Performance prima della fine della gara
  MAX_PERFORMANCE_INSERT = Time.zone.parse('2018-02-12 00:00:00')

  # Tempo massimo iscrizioni
  MAX_ISCRIZIONE = Time.zone.parse('2018-01-13 00:00:00')

  # Tempo massimo Inizio sfide
  MAX_TIME_FOR_START_CHALLENGES = MAX_PERFORMANCE_INSERT - MATCH_DURATION - 2.hours

  # Time to start challengers
  TIME_TO_START_CHALLENGES = Rails.application.secrets.challange_status == 'test' ? Time.now - 1.day : Time.zone.parse('2018-01-26 00:00:00')

  # Numero massimo di sfide come sfidante
  MAX_AS_CHALLENGER = 3

  # Numero massimo di sfide come sfidato
  MAX_AS_CHALLENGED = 3

end


