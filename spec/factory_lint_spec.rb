require 'rails_helper'

RSpec.describe 'Lint' do

  it 'check_all' do
    expect {
      FactoryBot.lint
    }.not_to raise_error
  end

end
