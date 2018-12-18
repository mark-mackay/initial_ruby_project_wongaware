require_relative( '../db/sql_runner' )

class Transaction

  attr_reader  :merchant_id , :tag_id , :id, :date_time
  attr_accessor :amount , :transaction_time, :transaction_date

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @merchant_id = options['merchant_id'].to_i
    @tag_id = options['tag_id'].to_i
    @amount = options['amount'].to_f
    @transaction_time = options['transaction_time']
    @transaction_date = options['transaction_date']
    @date_time = Time.parse(@transaction_date + ' ' + @transaction_time)
  end

  def save()
    sql = "INSERT INTO transactions
    (
      merchant_id,
      tag_id,
      amount,
      transaction_time,
      transaction_date
    )
    VALUES
    (
      $1, $2, $3, $4, $5
    )
    RETURNING id"
    values = [@merchant_id, @tag_id, @amount, @transaction_time, @transaction_date]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def update()
    sql = "UPDATE transactions
    SET
    (
      merchant_id,
      tag_id,
      amount,
      transaction_time,
      transaction_date
    ) =
    (
      $1, $2, $3, $4, $5
    )
    WHERE id = $6"
    values = [@merchant_id, @tag_id, @amount, @transaction_time, @transaction_date, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM transactions"
    results = SqlRunner.run( sql )
    return results.map { |transaction| Transaction.new( transaction ) }
  end

  def self.find( id )
    sql = "SELECT * FROM transactions
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run( sql, values )
    return Transaction.new( results.first )
  end

  def tag()
    sql = "SELECT * FROM tags
    WHERE id = $1"
    values = [@tag_id]
    results = SqlRunner.run( sql, values )
    return Tag.new( results.first )
  end

  def self.total()
    transactions = Transaction.all()
    return transactions.reduce(0) {|sum, transaction | sum + transaction.amount }
  end

  def self.transactions_by_tag(id)
    sql = "SELECT t.* FROM transactions t WHERE t.tag_id = $1;"
    values = [id]
    results = SqlRunner.run(sql, values)
    return results.map { |transaction| Transaction.new(transaction) }
  end

  def self.bymonth(yearmonth)
     return result = Transaction.all.select { | transaction | transaction.transaction_date.start_with?(yearmonth)}
  end

  def self.transactions_by_merchant(id)
    sql = "SELECT t.* FROM transactions t WHERE t.merchant_id = $1;"
    values = [id]
    results = SqlRunner.run(sql, values)
    return results.map { |transaction| Transaction.new(transaction) }
  end

  def merchant()
    sql = "SELECT * FROM merchants
    WHERE id = $1"
    values = [@merchant_id]
    results = SqlRunner.run( sql, values )
    return Merchant.new( results.first )
  end

  def self.delete_all()
    sql = "DELETE FROM transactions"
    SqlRunner.run( sql )
  end

  def self.delete(id)
    sql = "DELETE FROM transactions
    WHERE id = $1"
    values = [id]
    SqlRunner.run( sql, values )
  end

end
