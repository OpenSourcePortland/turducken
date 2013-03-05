class Animal
  attr_accessor :name
  def initialize(name)
    @name = name
  end
  
  def walk(question)
    puts "is it #{@name}?"
    response = gets.chomp
    check_response(response, question)
  end
  
  def first_walk
    puts "is it #{@name}?"
    response = gets.chomp
    check_response(response, Question.new("test", "test"))
  end
  
  def check_response(response, question)
    if response == "y"
      puts "I win!"
    else
      question.get_new_question(self)
    end
    
  end
  
end

class Question
  attr_accessor :yes, :no, :top_question
  
  def initialize(text, top)
    @text = text
    @top_question = top
  end
  
  def walk(nothing)
    response = ask_question
    if response == "y"
      yes.walk(self)
    else
      no.walk(self)
    end
  end
  
  def ask_question
    puts @text
    gets.chomp
  end
  
  def start_at_top
    @top_question.walk("")
  end
  
  def get_new_question(animal)
    puts "You win, help me get better by teling me what the animal was."
    new_animal = Animal.new(gets.chomp)
    puts "Give me a question to distinguish #{new_animal.name} from #{animal.name}."
    input = gets.chomp
    puts "For #{new_animal.name}, what is the answer to your question? (y or n)"    
    response = gets.chomp
    if @text == "test"
      @text = input
      self.top_question = self
      if response == "y" 
        self.no = animal
        self.yes = new_animal
      else
        self.no = new_animal
        self.yes = animal
      end
      puts "okay now think of a new animal1"
      walk("nothing", "nothing")
    else
      new_question = Question.new(input, self.top_question) 
    if prev_question == "y"   
    self.yes = new_question
    else
    self.no = new_question
    end
    if response == "y"
      new_question.yes = new_animal
      new_question.no = self
      puts "okay now think of a new animal2"
      start_at_top()
    else
      new_question.no = new_animal
      new_question.yes = self
      puts "okay now think of a new animal2"
      start_at_top()
    end 
    end 
    
  end
end

elephant = Animal.new("an elephant")
elephant.first_walk






