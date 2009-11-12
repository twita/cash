require "rubygems"
require "sqlite3"

require "include/Searchv2.rb"

@actions = Cour.new
@cours = @actions.cours
@valeur = @actions.valeur
@variations = @actions.variations
@ouverture = @actions.ouverture
@haut = @actions.haut
@bas = @actions.bas


#Création de la base de donnée cash.db
db = SQLite3::Database.new("cash.db")
#On efface la table boursier pour en créer une nouvelle
db.execute("drop table boursier")


sql_query = <<SQL
  create table boursier (
    Id integer primary key,
    Valeur text,
    Cours real,
    Variation real,
    Ouverture real,
    Haut real,
    Bas real);
    
SQL
db.execute_batch(sql_query)

#Remplissage de la base de donnée
def set_columns()
  db = SQLite3::Database.open("cash.db")
  
  for i in 0..@cours.length-1
    db.execute("insert into boursier (Valeur, Cours, Variation, Ouverture, Haut, Bas) values(?, ?, ?, ?, ?, ?)",
     @valeur[i].capitalize, @cours[i], @variations[i], @ouverture[i], @haut[i], @bas[i])
  end
end

#Extraction des colonnes de la base la table boursier
def get_columns()
  db = SQLite3::Database.open("cash.db")
  db.execute("select Valeur, Cours, Variation, Ouverture, Haut, Bas from boursier") do |v|
    puts v.join(" ")
  end
end


set_columns()
get_columns
db.close