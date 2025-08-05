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

pokemon_names = [
  "Turtwig", "Grotle", "Torterra",
  "Chimchar", "Monferno", "Infernape",
  "Piplup", "Prinplup", "Empoleon",
  "Starly", "Staravia", "Staraptor",
  "Bidoof", "Bibarel",
  "Kricketot", "Kricketune",
  "Shinx", "Luxio", "Luxray",
  "Budew", "Roserade",
  "Cranidos", "Rampardos",
  "Shieldon", "Bastiodon",
  "Burmy", "Wormadam", "Mothim",
  "Combee", "Vespiquen",
  "Pachirisu",
  "Buizel", "Floatzel",
  "Cherubi", "Cherrim",
  "Shellos", "Gastrodon",
  "Ambipom",
  "Drifloon", "Drifblim",
  "Buneary", "Lopunny",
  "Mismagius",
  "Honchkrow",
  "Glameow", "Purugly",
  "Chingling",
  "Stunky", "Skuntank",
  "Bronzor", "Bronzong",
  "Bonsly",
  "Mime Jr.",
  "Happiny",
  "Chatot",
  "Spiritomb",
  "Gible", "Gabite", "Garchomp",
  "Munchlax",
  "Riolu", "Lucario",
  "Hippopotas", "Hippowdon",
  "Skorupi", "Drapion",
  "Croagunk", "Toxicroak",
  "Carnivine",
  "Finneon", "Lumineon",
  "Mantyke",
  "Snover", "Abomasnow",
  "Weavile",
  "Magnezone",
  "Lickilicky",
  "Rhyperior",
  "Tangrowth",
  "Electivire",
  "Magmortar",
  "Togekiss",
  "Yanmega",
  "Leafeon",
  "Glaceon",
  "Gliscor",
  "Mamoswine",
  "Porygon-Z",
  "Gallade",
  "Probopass",
  "Dusknoir",
  "Froslass",
  "Rotom",
  "Uxie", "Mesprit", "Azelf",
  "Dialga", "Palkia", "Heatran",
  "Regigigas",
  "Giratina",
  "Cresselia",
  "Phione",
  "Manaphy",
  "Darkrai",
  "Shaymin",
  "Arceus"
]

pokemon_names_batch = pokemon_names.each_slice(15).to_a

classrooms = Classroom.all.to_a
plans = Plan.all.to_a

pokemon_names_batch.each_with_index do |pokemon_batch, index|
  classroom = classrooms[index % classrooms.size]

  pokemon_batch.each_with_index do |pokemon_name, sub_index|
    student = Student.create!(
      name: pokemon_name,
      status: :registered,
      cpf: format('000.000.000.%03d', index * 15 + sub_index + 1),
      classroom_id: classroom.id,
      cel_phone: format('3299922-%05d', index * 15 + sub_index + 1),
      email: "#{pokemon_name.downcase}@email.com"
    )

    plan = plans.sample
    has_discount = [true, false].sample
    discount = has_discount ? rand(5..30) : 0

    CurrentPlan.create!(
      student: student,
      plan: plan,
      has_discount: has_discount,
      discount: discount
    )
  end
end

