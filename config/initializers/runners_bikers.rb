module RunnersBikers

  VERSION = '1.0.11'

  PROGRAMM_STATUS = Rails.env.test? ? 'test' : Rails.application.secrets.challange_status

  # Durata Sfida
  MATCH_DURATION = PROGRAMM_STATUS == 'test' ? 10.minutes : 5.days

  # Tempo inizio inserimento Performance
  MIN_PERFORMANCE_INSERT = PROGRAMM_STATUS == 'test' ? Time.now - 1.month : Time.zone.parse('2018-02-04 00:00:00')

  # Tempo massimo inserimento Performance prima della fine della gara
  MAX_PERFORMANCE_INSERT = PROGRAMM_STATUS == 'test' ? Time.now + 1.month : Time.zone.parse('2018-03-05 00:00:00') + 2.hours

  # Tempo massimo iscrizioni
  MAX_ISCRIZIONE = PROGRAMM_STATUS == 'test' ? Time.now + 1.year : MIN_PERFORMANCE_INSERT #Time.zone.parse('2018-01-13 00:00:00')

  # Time to start challengers
  TIME_TO_START_CHALLENGES = PROGRAMM_STATUS == 'test' ? Time.now - 1.day : Time.zone.parse('2018-02-18 00:00:00')

  # Tempo massimo Inizio sfide
  MAX_TIME_FOR_START_CHALLENGES =  MAX_PERFORMANCE_INSERT - MATCH_DURATION - 2.hours

  # Numero massimo di sfide come sfidante
  MAX_AS_CHALLENGER = 3

  # Numero massimo di sfide come sfidato
  MAX_AS_CHALLENGED = 3

end


