require_relative( '../db/sql_runner' )

class Transaction

  attr_reader  :merchant_id , :tag_id , :id
  attr_accessor :amount , :transaction_time

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @merchant_id = options['merchant_id'].to_i
    @tag_id = options['tag_id'].to_i
    @amount = options['amount'].to_f
    @transaction_time = options['transaction_time']
  end

  def save()
    sql = "INSERT INTO transactions
    (
      merchant_id,
      tag_id,
      amount,
      transaction_time
    )
    VALUES
    (
      $1, $2, $3, $4
    )
    RETURNING id"
    values = [@merchant_id, @tag_id, @amount, @transaction_time]
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
      transaction_time
    ) =
    (
      $1, $2, $3, $4
    )
    WHERE id = $5"
    values = [@merchant_id, @tag_id, @amount, @transaction_time, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM transactions"
    results = SqlRunner.run( sql )
    return results.map { |transaction| Transaction.new( transaction ) }
  end

  def tag()
    sql = "SELECT * FROM tags
    WHERE id = $1"
    values = [@tag_id]
    results = SqlRunner.run( sql, values )
    return Tag.new( results.first )
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
