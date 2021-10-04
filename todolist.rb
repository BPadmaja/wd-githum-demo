require "date"

class Todo
  def initialize(msg, due_date, status)
    @text = msg
    @due_date = due_date
    @completed = status
  end

  def is_due_today?
    @due_date == Date.today
  end

  def is_overdue?
    ovd_status=@due_date < Date.today
    return ovd_status
  end

  def is_due_later?
    late_status=@due_date > Date.today
    return late_status
  end

  def to_displayable_string
    if (@completed)
      @status_mark = "X"
    else
      @status_mark = " "
    end
    if (is_due_today?)
      @show_date = " "
    else
      @show_date = @due_date
    end

    return "[#{@status_mark}] #{@text} #{@show_date}"
     
  end
end

class TodosList
  def initialize(todos)
    @todos = todos
  end

  def add(record)
    @todos.push(record)
  end

  def overdue
    TodosList.new(@todos.filter { |todo| todo.is_overdue? })
  end

  def due_today
    TodosList.new(@todos.filter { |todo| todo.is_due_today? })
  end

  def due_later
    TodosList.new(@todos.filter { |todo| todo.is_due_later? })
  end

  def to_displayable_list
    @todos.map { |todo| puts todo.to_displayable_string }.join("\n")
  end
end

date = Date.today
todos = [
  { text: "Submit assignment", due_date: date - 1, completed: false },
  { text: "Pay rent", due_date: date, completed: true },
  { text: "File taxes", due_date: date + 1, completed: false },
  { text: "Call Acme Corp.", due_date: date + 1, completed: false },
]

todos = todos.map { |todo|
  Todo.new(todo[:text], todo[:due_date], todo[:completed])
}

todos_list = TodosList.new(todos)

todos_list.add(Todo.new("Service Your vehicle", date, false))

puts "My Todo-list\n\n"

puts "Overdue\n"
puts todos_list.overdue.to_displayable_list
puts "\n\n"

puts "Due Today\n"
puts todos_list.due_today.to_displayable_list
puts "\n\n"

puts "Due Later\n"
puts todos_list.due_later.to_displayable_list
puts "\n\n"



