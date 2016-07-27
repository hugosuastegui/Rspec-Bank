class Account
  attr_reader :transactions

  def initialize(acct_number, starting_balance = 0)
    validate_number(acct_number)

    @acct_number  = acct_number
    @transactions = [ starting_balance ]
  end

  # acct_number must be 10 digits long
  # starting_balance has no restrictions

  def balance
    transactions.inject(:+)
  end

  # balance has no arguments, so it is valid for everything while there are transactions

  def acct_number
    hidden_length = @acct_number.length - 4
    @acct_number.sub(Regexp.new("^.{#{hidden_length}}"), "*" * hidden_length)
  end

  # acct_number method has no arguments so it has no restrictions

  def deposit!(amount)
    raise NegativeDepositError if amount < 0
    add_transaction(amount)

    balance
  end

  # amount must be an integer to validate this form

  def withdraw!(amount)
    amount = -amount if amount > 0
    add_transaction(amount)

    balance
  end

  # amount must be an integer to validate this form

  private

    def validate_number(number)
      unless valid_number?(number)
        raise InvalidAccountNumberError
      end
    end

    # number must be an integer

    def valid_number?(number)
      number.match /^\d{10}$/
    end

    # number must be an integer or a digit

    def add_transaction(amount)
      raise OverdraftError if balance + amount < 0
      transactions << amount

      self
    end
end

class InvalidAccountNumberError < StandardError; end
class NegativeDepositError < StandardError; end
class OverdraftError < StandardError; end
