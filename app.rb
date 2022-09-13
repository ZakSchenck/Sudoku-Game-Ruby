require "colorize"

class CreateGame
  # All possible sudoku boards
  @@sudoku_boards = [
    [
      [0, 0, 0, 2, 6, 0, 0, 0, 0],
      [6, 8, 0, 0, 7, 0, 0, 9, 0],
      [1, 9, 0, 0, 0, 4, 5, 0, 0],
      [8, 2, 0, 1, 0, 0, 0, 4, 0],
      [0, 0, 4, 6, 0, 2, 9, 0, 0],
      [0, 5, 0, 0, 0, 3, 0, 2, 8],
      [0, 0, 9, 3, 0, 0, 0, 7, 4],
      [0, 4, 0, 0, 5, 0, 0, 3, 6],
      [7, 0, 3, 0, 1, 8, 0, 0, 0],
    ],
    [
      [0, 2, 0, 6, 0, 8, 0, 0, 0],
      [5, 8, 0, 0, 0, 9, 7, 0, 0],
      [0, 0, 0, 0, 4, 0, 0, 0, 0],
      [3, 7, 0, 0, 0, 0, 5, 0, 0],
      [6, 0, 0, 0, 0, 0, 0, 0, 4],
      [0, 0, 8, 0, 0, 0, 0, 1, 3],
      [0, 0, 0, 0, 2, 0, 0, 0, 0],
      [0, 0, 9, 8, 0, 0, 0, 3, 6],
      [0, 0, 0, 3, 0, 6, 0, 9, 0],
    ],
    [
      [0, 0, 0, 6, 0, 0, 4, 0, 0],
      [7, 0, 0, 0, 0, 3, 6, 0, 0],
      [0, 0, 0, 0, 9, 1, 0, 8, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 5, 0, 1, 8, 0, 0, 0, 3],
      [0, 0, 0, 3, 0, 6, 0, 4, 5],
      [0, 4, 0, 2, 0, 0, 0, 6, 0],
      [9, 0, 3, 0, 0, 0, 0, 0, 0],
      [0, 2, 0, 0, 0, 0, 1, 0, 0],
    ],
  ]

  $line_chunk = 0
  $random_board = nil

  # Generates random sudoku table
  def generate_random_board
    @board_num = @@sudoku_boards.length() - 1
    $random_board = rand(0..@board_num)
    $random_board = @@sudoku_boards[$random_board]
  end

  # Initial board display
  def display_board
    while ($line_chunk < 8)
      puts "#{"#{$line_chunk}".green} #{$random_board[$line_chunk]}"
      $line_chunk += 1
    end
  end
end

class PlayGame
  @@board_selector_array = []
  @@game_is_active = true

  # Function containing all user input
  def take_input
    while @@game_is_active
      # Gets column board input
      puts "#{"#{$line_chunk}".green} #{$random_board[$line_chunk]}"
      puts "Which row would you like to use?"
      @col_input = gets.chomp()
      while Integer(@col_input) < 0 || Integer(@col_input) > 8
        puts "Error. Choose a number 0 through 8.".red
        puts "Which row would you like to use?"
        @col_input = gets.chomp()
      end

      $line_chunk = 0
      # Displays row board
      puts " 0  1  2  3  4  5  6  7  8 ".green
      while ($line_chunk < 9)
        puts "#{$random_board[$line_chunk]}"
        $line_chunk += 1
      end

      # Functionality getting the column input
      puts "Which column would you like to use?"
      @row_input = gets.chomp()
      while Integer(@row_input) < 0 || Integer(@row_input) > 8
        puts "Error. Choose a number 1 through 8.".red
        puts "Which column would you like to use?"
        @row_input = gets.chomp()
      end

      # Pushes current indexes into array to display
      @@board_selector_array.push([Integer(@col_input), Integer(@row_input)])

      $line_chunk = 0

      # Shows the currently used Row/Col indexes
      puts "These are the indexes you have used:".blue
      puts "#{@@board_selector_array}".blue

      update_board()
      print_updated_board()
      check_winner_handler($random_board)

      # Removes all indexes from array
      @@board_selector_array = []
    end
  end

  # Updates board with new number
  def update_board
    puts "Choose a number one through nine to place"
    new_num = gets.chomp()
    while (Integer(new_num) < 1 || Integer(new_num) > 9)
      puts "Error: Choose a number one through nine to place".red
      new_num = gets.chomp()
    end

    puts "Here is your new board"
    $random_board[Integer(@col_input)][Integer(@row_input)] = Integer(new_num)
  end

  # Prints updated sudoku board
  def print_updated_board
    while ($line_chunk < 9)
      puts "#{"#{$line_chunk}".green} #{$random_board[$line_chunk]}".green
      $line_chunk += 1
    end
  end

  def check_winner_handler(board)
    required_nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    chunk = 0
    checker_array = []
    vertical_diag_array = []

    # Checks if all horizontal rows contain all nums 1 through 9
    while chunk < 9
      if (required_nums.all? { |nums| board[chunk].include? nums })
        checker_array.push(true)
      else
        checker_array.push(false)
      end
      chunk += 1
    end

    # Resets chunk to 0 for new checker
    chunk = 0

    # Checks if all diagonal nums contains 1 through 9
    while chunk < 9
      vertical_diag_array.push(board[chunk][chunk])
      if (required_nums.all? { |nums| board[chunk].include? nums })
        checker_array.push(true)
      else
        checker_array.push(false)
      end
      chunk += 1
    end

    chunk = 0
    vertical_diag_array = []

    # Checks if all vertical rows contains all nums 1 through 9
    while chunk < 9
      for index in 0..8
        vertical_diag_array.push(board[index][chunk])
      end
      if (required_nums.all? { |nums| board[chunk].include? nums })
        checker_array.push(true)
      else
        checker_array.push(false)
      end
      chunk += 1
    end

    if (checker_array.all? { |num| num == true })
        puts "YOU WON!!!".green
      @@game_is_active = false
    end
  end
end

NewGame = CreateGame.new()
NewGame.generate_random_board
NewGame.display_board
PlayerInput = PlayGame.new()
PlayerInput.take_input
