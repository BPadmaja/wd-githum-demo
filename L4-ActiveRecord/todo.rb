require "./connect_db.rb"
require "./todo.rb"

connect_db!
Todo.show_list
root@DESKTOP-NRR7F6C:~# cat todo.rb
class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.add_task(h)
    Todo.create!(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
  end

  def self.mark_as_complete(id)
    todo = Todo.find(id)
    todo.completed = true
    todo.save
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    overdue = all.filter { |todo| todo.overdue? }
    overdue.map { |todo| puts todo.to_displayable_string }.join("\n")
    puts "\n\n"

    puts "Due Today\n"
    overdue = all.filter { |todo| todo.due_today? }
    overdue.map { |todo| puts todo.to_displayable_string }.join("\n")
    puts "\n\n"

    puts "Due Later\n"
    overdue = all.filter { |todo| todo.due_later? }
    overdue.map { |todo| puts todo.to_displayable_string }.join("\n")
    puts "\n\n"
  end
end
