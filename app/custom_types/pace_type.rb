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
    else
      super
    end
  end

  def serialize(value) # value here is a StringInquiry
    to_seconds(value)
  end

  private
  def to_seconds(value)
    if value.is_a?(String)
      ris = value.match(/(?<minuti>[0-9]+):(?<secondi>[0-9]+)/)
      ris[:minuti].to_i*60+ris[:secondi].to_i
    else
      value
    end
  end

end

ActiveRecord::Type.register(:pace, PaceType)