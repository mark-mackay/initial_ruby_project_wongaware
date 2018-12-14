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

  # def victims
  #   sql = "SELECT v.* FROM victims v INNER JOIN bitings b ON b.victim_id = v.id WHERE b.zombie_id = $1;"
  #   values = [@id]
  #   results = SqlRunner.run(sql, values)
  #   return results.map { |victim| Victim.new(victim) }
  # end

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

  def self.delete_all
    sql = "DELETE FROM tags"
    SqlRunner.run( sql )
  end

end
