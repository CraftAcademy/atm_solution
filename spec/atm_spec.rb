require './lib/atm.rb'
describe Atm do
  let(:account) { class_double('Account', pin_code: '1234', exp_date: '04/17') }

  before do
    # Before each test we need to add an attribute of `balance`
    # to the `account` object and set the value to `100`
    allow(account).to receive(:balance).and_return(100)
    # We also need to allow `account` to receive the new balance
    # using the setter method `balance=`
    allow(account).to receive(:balance=)
    allow(account).to receive(:pin)
  end

  it 'has 1000$ on intitialize' do
    expect(subject.funds).to eq 1000
  end

  it 'funds are reduced at withdraw' do
    subject.withdraw(50, '1234', account)
    expect(subject.funds).to eq 950
  end

  it 'allow withdraw if account has enough balance.' do
    # We need to tell the spec what to look for as the responce
    # and store that in a variable called `expected_outcome`.
    # Please note that we are omitting the `bills` part at the moment,
    # We will modify this test and add that later.

    expected_output = { status: true, message: 'success', date: Date.today, amount: 45 }

    # We need to pass in two arguments to the `withdraw` method.
    # The amount of money we want to withdraw AND the `account` object.
    # The reason we pass in the `account` object is that the Atm needs
    # to be able to access information about the `accounts` balance
    # in order to be able to clear the transaction.
    expect(subject.withdraw(45, '1234', account)).to eq expected_output
  end

  it 'reject withdraw if account has insufficient funds' do
    expected_output = { status: false, message: 'insufficient funds in account', date: Date.today }
    # We know that the account created for the purpose of this test
    # has a balance of 100. So let's try to withdraw
    # a larger amount. In this case 105.
    expect(subject.withdraw(105, '1234', account)).to eq expected_output
  end

  it 'reject withdraw if ATM has insufficient funds' do
    # To prepare the test we want to decrease the funds value
    # to a lower value then the original 1000
    subject.funds = 50
    # Then we set the `expected_output`
    expected_output = { status: false, message: 'insufficient funds in ATM', date: Date.today }
    # And prepare our assertion/expectation
    expect(subject.withdraw(100, '1234', account)).to eq expected_output
  end

  it 'reject withdraw if pin is wrong' do
    expected_output = { status: false, message: 'wrong pin', date: Date.today }
    expect(subject.withdraw(50, '9999', account)).to eq expected_output
  end

  it 'reject withdraw if card is expired' do
    allow(account).to receive(:exp_date).and_return('12/15')
    expected_output = { status: false, message: 'card expired', date: Date.today }
    expect(subject.withdraw(6, '1234', account)).to eq expected_output
  end
end
