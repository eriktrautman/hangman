
# Hangman!
class HangmanGame

    attr_reader :dictionary, :incorrect_guesses, :current_showing_word

    DICTIONARY = "2of4brif.txt"
    MAX_GUESSES = 5
    MIN_WORD_SIZE = 4

    def initialize(num_of_humans)
        @num_of_humans = num_of_humans
        @incorrect_guesses = []
        print_instructions
        create_players
    end


    def play

        read_dictionary
        @secret_word = @checker.choose_word
        @current_showing_word = "_" * @secret_word.size
        trim_dictionary

        print_game

        until game_over?
            current_guess = @guesser.guess
            change_gameboard(current_guess)
            print_game
        end

        if victory?
            puts "GOOD JOB"
        else
            puts "FAIL. The word was #{@secret_word}"
        end
    end

    def print_game
        puts "Game board:"
        @current_showing_word.each_char do |c|
            print "#{c} "
        end
        puts "incorrect_guesses: #{@incorrect_guesses.inspect}"
    end

    def change_gameboard(current_guess)
        if @secret_word.include?(current_guess)
            @secret_word.split('').each_with_index do |c, i|
                if c == current_guess
                    @current_showing_word[i] = c
                end
            end
            prune_dictionary
        else
            @incorrect_guesses << current_guess
        end
    end


    def read_dictionary
        @dictionary = []
        File.foreach("2of4brif.txt") {|line| @dictionary << line.strip.downcase  }
    end

    def trim_dictionary
        @dictionary.select! {|word| word.size == @secret_word.size}
    end

    def prune_dictionary
        temp_dic = []
        words_showing = 0

        @current_showing_word.each_char do |c|
            if ("a".."z").include?(c)
                words_showing +=1
            end
        end
        #puts "Dictionary: #{@dictionary.inspect}"
        @dictionary.each do |word|
            chars_same = 0

            word.split("").each_with_index do |char, i|
                if @current_showing_word[i] == char
                    chars_same +=1
                end
            end

            if chars_same == words_showing
                    temp_dic << word
            end
        end
        @dictionary =  temp_dic
    end

    def print_instructions
        puts "Welcome to Hangman!"
    end

    # will build the appropriate number and type of player objects (AI or human)
    def create_players
        case @num_of_humans
        when 0   # create two AIs
            @guesser, @checker = AI.new(self), AI.new(self)
        when 2 # create two humans
            @guesser, @checker = Human.new(self), Human.new(self)
        else
            if player1_role == "g"
                @guesser, @checker = Human.new(self), AI.new(self)
            else
                @checker, @guesser = Human.new(self), AI.new(self)
            end
        end

    end

    def player1_role
        puts "Type in 'g' to become guesser or 'c' to become checker."
        while true
            choice = gets.chomp
            return choice if ["g","c"].include?(choice)
        end
    end

    def game_over?
        victory? || failure?
    end

    def victory?
        if @current_showing_word.include?("_")
            false
        else
            true
        end
    end

    def failure?
        @incorrect_guesses.size >= MAX_GUESSES
    end


end


class AI

    def initialize(hangman_game)
        @hangman_game = hangman_game
    end

    def choose_word
        chosen_word = ""
        until chosen_word.size >= HangmanGame::MIN_WORD_SIZE
            chosen_word = @hangman_game.dictionary.sample
        end
        chosen_word
    end

    # returns a guessed letter
    def guess
        @letter_frequency = Hash.new(0)
        @hangman_game.dictionary.join.each_char do |c|
            if @hangman_game.incorrect_guesses.include?(c) || @hangman_game.current_showing_word.split("").include?(c)
                @letter_frequency[c] = 0
            else
                @letter_frequency[c] +=1
            end
        end
        return @letter_frequency.max_by { |k,v| v }[0]
    end

end

class Human

    def initialize(hangman_game)
        @hangman_game = hangman_game
    end

    def choose_word
        while true
            puts "Choose your word.  It must be at least #{HangmanGame::MIN_WORD_SIZE} letters."
            chosen_word = gets.chomp
            return chosen_word if chosen_word.size >= HangmanGame::MIN_WORD_SIZE
        end
    end

    def guess
        puts "Guess a letter:"
        gets.downcase.chomp
    end

end



# SCRIPT
h = HangmanGame.new(0)
h.play



