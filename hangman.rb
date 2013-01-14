
# Hangman!
class HangmanGame

    attr_reader :dictionary

    DICTIONARY = "2of4brif.txt"
    MAX_GUESSES = 10
    MIN_WORD_SIZE = 4

    def initialize(num_of_humans)
        @num_of_humans = num_of_humans
        print_instructions
        create_players
        choose_roles if @num_of_humans == 1
    end


    def play

        secret_word = @checker.choose_word

        until game_over?
            current_guess = @guesser.guess
            change_gameboard if @checker.valid_guess?(current_guess)
            print_game
        end

        print winner
    end


    def read_dictionary
        @dictionary = File.readlines(DICTIONARY) {|line| line.chomp}
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
    end

    def failure?
    end


end

class Player
    def initialize(hangman_game)
        @hangman_game = hangman_game
    end
end

class AI < Player

    def choose_word
        chosen_word = @hangman_game.dictionary.sample until chosen_word.size >= MIN_WORD_SIZE
    end

    def valid_guess?(current_guess)
    end

    def guess
    end

end

class Human < Player

    def choose_word
        while true
            puts "Choose your word.  It must be at least #{MIN_WORD_SIZE} letters."
            chosen_word = gets.chomp
            return chosen_word if chosen_word.size >= MIN_WORD_SIZE
        end
    end

    def valid_guess?(current_guess)
    end

    def guess
    end

end







