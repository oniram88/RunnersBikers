##
# Classe che definisce un tipo di dato per semplificare la registrazione del
# valore del ritmo
class PaceType < ActiveRecord::Type::Value

  def type
    :pace
  end

  def deserialize(value)
    if value.is_a?(String)
      to_seconds(value)
    elsif value.is_a?(Integer)
      "%02d:%02d" % value.divmod(60)
    else
      super
    end
  end

  def serialize(value) # value here is a String
    to_seconds(value)
  end


  def self.serialize(value)
    to_seconds(value)
  end

  def self.reg_exp
    /\A(?<minuti>[0-5]?[0-9]):(?<secondi>([0-5][0-9]))\Z/
  end

  def to_seconds(value)
    self.class.to_seconds(value)
  end

  def self.to_seconds(value)
    if value.is_a?(String) and value.match(reg_exp)
      ris = value.match(reg_exp)
      ris[:minuti].to_i * 60 + ris[:secondi].to_i
    else
      value
    end
  end


end

ActiveRecord::Type.register(:pace, PaceType)