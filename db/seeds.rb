# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# teacher_names = [
#   'Ash', 'Brock', 'Mist', 'Giovanni', 'Oak', 'Briar', 'Surge', 'Gary', 'Red', 'Ethan'
# ]

# teacher_names.each_with_index do |name, index|
#   user = User.create!(
#     email: "#{name.downcase}#{index + 1}@email.com", 
#     password: 'nonono00', 
#     role: 'teacher', 
#     cpf: format('000.000.000.%02d', index + 1)
#   )

#   teacher = Teacher.create!(
#     name: name, 
#     status: :disponível, 
#     cel_phone: format('3299922-%05d', index + 1), 
#     user_id: user.id
#   )

#   # Gerar horário incremental com base no índice
#   time = "#{8 + (index % 12)}:00" # Mantém horários dentro de 8h às 19h
#   period = index.even? ? 'MW' : 'TT'

#   Classroom.create!(
#     name: "#{time} #{period}", 
#     teacher_id: teacher.id, 
#     time: time
#   )
# end

pokemon_names_batch = [
  ['Bulbasaur', 'Ivysaur', 'Venusaur', 'Charmander', 'Charmeleon', 'Charizard',
   'Squirtle', 'Wartortle', 'Blastoise', 'Caterpie', 'Metapod', 'Butterfree',
   'Weedle', 'Kakuna', 'Beedrill'],
  ['Pidgey', 'Pidgeotto', 'Pidgeot', 'Rattata', 'Raticate', 'Spearow', 'Fearow',
   'Ekans', 'Arbok', 'Pikachu', 'Raichu', 'Sandshrew', 'Sandslash', 'Nidoran♀',
   'Nidorina'],
  ['Nidoqueen', 'Nidoran♂', 'Nidorino', 'Nidoking', 'Clefairy', 'Clefable',
   'Vulpix', 'Ninetales', 'Jigglypuff', 'Wigglytuff', 'Zubat', 'Golbat', 'Oddish',
   'Gloom', 'Vileplume'],
  ['Paras', 'Parasect', 'Venonat', 'Venomoth', 'Diglett', 'Dugtrio', 'Meowth',
   'Persian', 'Psyduck', 'Golduck', 'Mankey', 'Primeape', 'Growlithe', 'Arcanine',
   'Poliwag'],
  ['Poliwhirl', 'Poliwrath', 'Abra', 'Kadabra', 'Alakazam', 'Machop', 'Machoke',
   'Machamp', 'Bellsprout', 'Weepinbell', 'Victreebel', 'Tentacool', 'Tentacruel',
   'Geodude', 'Graveler'],
  ['Golem', 'Ponyta', 'Rapidash', 'Slowpoke', 'Slowbro', 'Magnemite', 'Magneton',
   'Farfetch’d', 'Doduo', 'Dodrio', 'Seel', 'Dewgong', 'Grimer', 'Muk',
   'Shellder'],
  ['Cloyster', 'Gastly', 'Haunter', 'Gengar', 'Onix', 'Drowzee', 'Hypno',
   'Krabby', 'Kingler', 'Voltorb', 'Electrode', 'Exeggcute', 'Exeggutor', 'Cubone',
   'Marowak'],
  ['Hitmonlee', 'Hitmonchan', 'Lickitung', 'Koffing', 'Weezing', 'Rhyhorn',
   'Rhydon', 'Chansey', 'Tangela', 'Kangaskhan', 'Horsea', 'Seadra', 'Goldeen',
   'Seaking', 'Staryu'],
  ['Starmie', 'Mr. Mime', 'Scyther', 'Jynx', 'Electabuzz', 'Magmar', 'Pinsir',
   'Tauros', 'Magikarp', 'Gyarados', 'Lapras', 'Ditto', 'Eevee', 'Vaporeon',
   'Jolteon'],
  ['Flareon', 'Porygon', 'Omanyte', 'Omastar', 'Kabuto', 'Kabutops', 'Aerodactyl',
   'Snorlax', 'Articuno', 'Zapdos', 'Moltres', 'Dratini', 'Dragonair', 'Dragonite',
   'Mewtwo', 'Mew']
]

classrooms = Classroom.all.to_a # Obtém todas as salas existentes no banco

pokemon_names_batch.each_with_index do |pokemon_batch, index|
  # Obtém a sala correspondente ao índice
  classroom = classrooms[index % classrooms.size] # Garante que os Pokémon sejam distribuídos circularmente

  # Criar estudantes para cada Pokémon no subarray
  pokemon_batch.each_with_index do |pokemon_name, sub_index|
    Student.create!(
      name: pokemon_name, 
      status: :registered, 
      cpf: format('000.000.000.%03d', index * 15 + sub_index + 1), 
      classroom_id: classroom.id, 
      cel_phone: format('3299922-%05d', index * 15 + sub_index + 1), 
      email: "#{pokemon_name.downcase}@email.com"
    )
  end
end

