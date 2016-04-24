class Account
  attr_accessor :pin_code, :balance, :exp_date, :account_status, :owner
  STANDARD_VALIDITY_YRS = 5


  def initialize(attrs = {})
    @pin_code = generate_pin
    @balance = attrs[:balance] || 0
    @exp_date = set_exp_date
    @account_status = :active
    set_owner(attrs[:owner])
  end

  def self.deactivate(account)
    account.account_status = :deactivated
  end

  def deactivate
    @account_status = :deactivated
  end

  private

  def generate_pin
    rand(1000..9999)
  end

  def set_exp_date
    Date.today.next_year(STANDARD_VALIDITY_YRS).strftime("%m/%y")
  end

  def set_owner(obj)
    obj == nil ?  missing_owner : @owner = obj
  end

  def missing_owner
    raise "An Account owner is required"
  end
end
