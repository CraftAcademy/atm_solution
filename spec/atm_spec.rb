require './lib/atm.rb'
describe Atm do
  it 'has 1000$ on intitialize' do
    expect(subject.balance).to eq 1000
  end

  it 'balance is reduced at withdraw' do
    subject.withdraw 50
    expect(subject.balance).to eq 950
  end
end
