require_relative( '../db/sql_runner' )

class User

  attr_reader( :name, :budget, :id )

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @budget = options['budget'].to_i
  end

  def save()
    sql = "INSERT INTO users
    (
      name,
      budget
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @budget]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def update()
    sql = "UPDATE users
    SET
    (
      name,
      budget
    ) =
    (
      $1, $2
    )
    WHERE id = $3"
    values = [@name, @budget, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM users"
    results = SqlRunner.run( sql )
    return results.map { |user| User.new( user ) }
  end

  def self.budget_warning
     user = User.all.first
     return user.budget < Transaction.total + 50.0
  end

  def self.find( id )
    sql = "SELECT * FROM users
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run( sql, values )
    return User.new( results.first )
  end

  def self.delete_all
    sql = "DELETE FROM users"
    SqlRunner.run( sql )
  end


end
