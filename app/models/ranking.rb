#
# Semplice modello che si occupa di gestire le policy della visualizzazione
# del ranking
class Ranking < User


  def total_points
    performances.sum(:points)
  end

  def total_distance
    performances.sum(:distance)
  end

  def total_positive_gain
    performances.sum(:positive_gain)
  end

end