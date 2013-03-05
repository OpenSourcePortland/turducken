require 'yaml'

class Animal
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end
  
  def walk
    puts "Is it a #{@name}?"
    answer = gets.chomp
    if answer == "yes"
      puts "I win!"
    else
      puts "You win, can you help me learn by telling me what animal you were thinking of?"
      new_animal = Animal.new(gets.chomp)
      puts "Can you give me a question that would help me differentiate between a #{@name} and a #{new_animal.name}"
      question = gets.chomp
      puts "What should the answer be?"
      if gets.chomp == "yes"
        Question.new(question, new_animal, self)
      else
        Question.new(question, self, new_animal)
      end
    end
  end
end

class Question
  attr_accessor :text, :yay, :nay
  
  def initialize(question, yay, nay)
    @question = question
    @yay = yay
    @nay = nay
  end
  
  def walk
    puts @question
    response = gets.chomp
    if response == "yes"
      @yay = @yay.walk
      puts "done yay walking"
    else
      @nay = @nay.walk
      puts "done nay walking"
    end
    puts "returning self: #{self.inspect}"
    self
  end
end

if File.exists? "turducken.yaml"
  current = open("turducken.yaml") { |f| YAML.load(f.read) }
else
  current = Animal.new("elephant")
end


loop do
current = current.walk
puts "current is #{current.inspect}"
puts "play again?"
break if gets.chomp == "no"
end

open("turducken.yaml", "w") do |f| f.puts current.to_yaml end
