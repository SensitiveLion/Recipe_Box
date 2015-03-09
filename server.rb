require "sinatra"
require "pg"
require "pry"

##define methods##

def db_connection
begin
connection = PG.connect(dbname: "recipes")
yield(connection)
ensure
connection.close
end
end

def get_recipes
  db_connection do |conn|
    conn.exec("SELECT * FROM recipes ORDER BY name")
  end
end

def get_one_recipe
  db_connection do |conn|
    conn.exec("SELECT * FROM recipes WHERE id = #{params[:id]}")
  end
end

def get_ingretients
  db_connection do |conn|
    conn.exec("SELECT * FROM ingredients WHERE recipe_id = #{params[:id]}")
  end
end

##calls to pages##

get "/" do
  redirect "/recipes"
end

get "/recipes" do
  recipes = get_recipes
  erb :index, locals: { recipes: recipes }
end

get "/recipes/:id" do
  recipe = get_one_recipe
  ingredients = get_ingretients
  erb :show, locals: { ingredients: ingredients, recipe: recipe }
end