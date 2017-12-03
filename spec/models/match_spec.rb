# == Schema Information
#
# Table name: matches
#
#  id            :integer          not null, primary key
#  challenged_id :integer
#  challenger_id :integer
#  status        :integer
#  points        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Match, type: :model do



end
