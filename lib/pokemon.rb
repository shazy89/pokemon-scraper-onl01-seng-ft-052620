require 'pry'
require_relative "../bin/environment"


class Pokemon
    attr_accessor :name, :type, :id, :db
    
      def initialize(name:, type:, id:, db:)
        @name = name
        @type = type
        @id = id
      end
    
      def self.save(pk_name, pk_type, db)
          sql = <<-SQL
          INSERT INTO pokemon (name, type)
          VALUES (?, ?)
          SQL
          db.execute(sql, pk_name, pk_type)
          @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
      end
    
      def self.create(name, type)
        pk_name = name
        pk_type = type
        new_pokemon = self.new(pk_name, pk_type)
        new_pokemon.save
      end
    
      def self.new_from_db(row, db)
        id = row[0]
        pk_name = row[1]
        pk_type = row[2]
        new_pokemon = self.new(name: pk_name, type: pk_type, id: id, db: db)
        new_pokemon
      end
    
      def self.find(id, db)
        sql = <<-SQL
        SELECT *
        FROM pokemon
        WHERE id = ?
        LIMIT 1
        SQL
        row = db.execute(sql, id)[0]
          self.new_from_db(row, db)
      end
    
      def update
        sql = "UPDATE pokemon SET name = ?, type = ? WHERE id = ?"
        db.execute(sql, self.name, self.type, self.id)
      end
    binding.pry
    end