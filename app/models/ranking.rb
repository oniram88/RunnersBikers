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
#  total_points           :decimal(15, 3)   default(0.0)
#  username               :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

#
# Semplice modello che si occupa di gestire le policy della visualizzazione
# del ranking
class Ranking < User


  def total_distance
    performances.sum(:distance)
  end

  def total_positive_gain
    performances.sum(:positive_gain)
  end

  def max_lose_points(user)
    self.class.max_loose_points(user, self)
  end

  def self.max_loose_points(u1, u2)
    ([u1.total_points, u2.total_points].min * 0.25).to_i
  end

end
