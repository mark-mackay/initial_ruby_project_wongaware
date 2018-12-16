require_relative( '../db/sql_runner' )

class Merchant

  attr_reader :name, :id

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO merchants
    (
      name
    )
    VALUES
    (
      $1
    )
    RETURNING id"
    values = [@name]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def tags()
    sql = "SELECT t.* FROM tags t INNER JOIN transactions a ON a.tag_id = t.id WHERE a.merchant_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map { |tag| Tag.new(tag) }
  end

  def self.all()
    sql = "SELECT * FROM merchants"
    results = SqlRunner.run( sql )
    return results.map { |hash| Merchant.new( hash ) }
  end

  def self.find( id )
    sql = "SELECT * FROM merchants
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run( sql, values )
    return Merchant.new( results.first )
  end

  def update()
    sql = "UPDATE merchants
    SET
    (
      name
    ) =
    (
      $1
    )
    WHERE id = $2"
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM merchants"
    SqlRunner.run( sql )
  end

  def self.delete(id)
    sql = "DELETE FROM merchants
    WHERE id = $1"
    values = [id]
    SqlRunner.run( sql, values )
  end

end
