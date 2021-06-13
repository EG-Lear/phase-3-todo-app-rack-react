puts "Clearing old data..."
Category.destroy_all
Task.destroy_all

puts "Seeding Categories..."


cat_1 = Category.create(name: "Cat1")
cat_2 = Category.create(name: "Cat2")


puts "Seeding tasks..."


task_1 = Task.create(text: "test text 1")
task_2 = Task.create(text: "test text 2")
task_3 = Task.create(text: "test text 3")

task_1.category = cat_1
task_2.category = cat_2
task_3.category = cat_2

cat_1.tasks << task_1
cat_2.tasks << task_2
cat_2.tasks << task_3


puts "Done!"