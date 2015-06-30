class Employee
  attr_accessor :name, :boss, :title, :salary

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end

  def bonus(multiplier)
    bonus = (salary) * multiplier
  end

end


class Manager < Employee

  def initialize(name, title, salary)
    super
    @employees = []
  end

  def bonus(multiplier)
    bonus = all_employee_salaries.inject(0) { |accum, salary| accum + salary }
    bonus * multiplier
  end

  def all_employee_salaries
    @employees.map { |employee| employee.salary }
  end

  def add_employee(*employee)
    employee.each do |person|
      @employees << person
      person.boss = self
    end
  end

end


shirley = Manager.new("Shirley", "Boss", 1_000_000)

bob = Employee.new("Bob", "WorkerBee", 10)
george = Employee.new("George", "WorkerBee", 15)


puts shirley.name

shirley.add_employee(bob, george)

p bob.bonus(4)
p shirley.bonus(5)
