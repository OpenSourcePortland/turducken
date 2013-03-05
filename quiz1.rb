module Convert
  def get_value(card)
    (card == "B") || (card =="A") ? 53 : card
  end

  def normalize_number(num)
    num -= 26 if num > 26
    return num
  end 
end

class Deck
  include Convert
 
  attr_accessor :keystream

  def initialize
    @deck = (1..52).to_a
    @deck.push("A", "B")  
    @keystream = []
    @alpha_key = ('A'..'Z').to_a
  end

  def shuffle             
    move("A", 1)          #2. Move the A joker down one card.
    move("B", 2)          #3. Move the B joker down two cards.
    triple_cut(@deck)     #4. Perform a triple cut around the two jokers. 
    count_cut(@cut_deck)  #5. Perform a count cut using the bottom card value 
    find_letter           #6. Find the output letter and add to keystream
  end
  
  private
  
  def move(card, number)
    card_index = @deck.index(card)
    new_card_index = card_index + number
    if new_card_index > 53
      new_card_index = (new_card_index % 53)
    end
    @deck.delete_at(card_index)
    @deck.insert(new_card_index, card)
  end

  def triple_cut(passed_deck)
    jokers = [passed_deck.index("A"), passed_deck.index("B")].sort
    first = jokers[0]
    last = jokers[1]
    after_last = passed_deck[(last + 1)..53]
    before_first = passed_deck[0...first]
    middle = passed_deck[first..last]
    @cut_deck = [after_last, middle, before_first].flatten
  end

  def count_cut(passed_deck)
    value = get_value(passed_deck.last) 
    chunk1 = passed_deck[0...value]
    chunk2 = passed_deck[value...53]
    @count_cut_deck = [chunk2, chunk1, passed_deck.last].flatten
    @deck = @count_cut_deck
  end  

  def find_letter
    # Generate a keystream with each letter in the message.
    top_card = get_value(@count_cut_deck.first)
    convert_card = normalize_number(get_value(@count_cut_deck[top_card]))
    letter = @alpha_key[(convert_card - 1)]
    @keystream << letter 
  end

end

class Message
  include Convert
  
  attr_accessor :prompt
  
  def initialize
  @alpha_key = ('A'..'Z').to_a
  @prompt = "> "
  end
  
  def get_input_and_run_cypher(type)     
    #Get phrase from user   
    puts "please enter the message you would like to #{type}"
    print @prompt
    phrase = STDIN.gets.chomp 
    
    #Key the deck and use Solitaire to generate a keystream
    cards = Deck.new
      (phrase.length + 1).times do
       cards.shuffle
      end
    
    #combine the phrase and the keystream and return the encoded or decoded message  
    numeric_keystream = convert_to_integers(cards.keystream) 
    numeric_message = convert_to_integers(simple_sanitize(phrase))
    if type == "encrypt"
      numeric_combo = numeric_message.map.with_index{ |m,i| m + numeric_keystream[i].to_i}
    else
      numeric_combo = numeric_message.map.with_index{ |m,i| m - numeric_keystream[i].to_i}
    end
    convert_to_letters(numeric_combo)
  end
  
  private
  
  def simple_sanitize(phrase)
    new_message = phrase.upcase.gsub(/\W+/, '').scan(/.{1,5}/)
    if new_message.last.length < 5
      padding = 5 - new_message.last.length
      new_message.last << ("X" * padding)
    end
    return new_message
  end

  def convert_to_integers(phrase) # Convert the message into numbers
    num_message = []
    phrase = phrase.join.scan(/.{1,1}/)
    phrase.each do |l|
      num_message << (@alpha_key.index(l) + 1 )
    end
    return num_message
  end

  def convert_to_letters(phrase) # Convert the numbers back to letters
    alpha_message = []
    phrase.each do |i|
      i = normalize_number(i)
      alpha_message << @alpha_key[(i-1)]
    end
    alpha_message = alpha_message.join.scan(/.{1,5}/)
    puts alpha_message
  end
end
    
message = Message.new

puts "Welcome to the solitaire cypher enter 1 to encrypt a message, enter 2 to decrypt a message"
print message.prompt
answer = STDIN.gets.chomp
if answer == "1"
  message.get_input_and_run_cypher("encrypt")
elsif answer == "2"
  message.get_input_and_run_cypher("decrypt")
else
  puts "sorry that was not an acceptable answer"
end