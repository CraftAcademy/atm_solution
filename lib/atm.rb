class Atm
  attr_accessor :balance

  def initialize
    @balance = 1000
  end

  def withdraw(amount)
    @balance -= amount
  end
end
