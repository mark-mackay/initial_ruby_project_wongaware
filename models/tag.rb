require_relative( '../db/sql_runner' )

class Tag

  attr_reader :id
  attr_accessor :type

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @type = options['type']
  end

  def save()
    sql = "INSERT INTO tags
    (
      type
    )
    VALUES
    (
      $1
    )
    RETURNING id"
    values = [@type]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def merchants()
    sql = "SELECT m.* FROM merchants m INNER JOIN transactions t ON t.merchant_id = m.id WHERE t.tag_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map { |merchant| Merchant.new(merchant) }
  end

  def self.transactions(id)
    sql = "SELECT t.* FROM transactions t WHERE t.tag_id = $1;"
    values = [id]
    results = SqlRunner.run(sql, values)
    return results.map { |transaction| Transaction.new(transaction) }
  end

  def self.all()
    sql = "SELECT * FROM tags"
    results = SqlRunner.run( sql )
    return results.map { |hash| Tag.new( hash ) }
  end

  def self.find( id )
    sql = "SELECT * FROM tags
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run( sql, values )
    return Tag.new( results.first )
  end

  def update()
    sql = "UPDATE tags SET (type) = ROW($1) WHERE id = $2;"
    values = [@type, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM tags"
    SqlRunner.run( sql )
  end

  def self.delete(id)
        sql = "DELETE FROM tags
        WHERE id = $1"
        values = [id]
        SqlRunner.run( sql, values )
  end

end
