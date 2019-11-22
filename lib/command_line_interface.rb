require "tty-prompt"
require "pry"
require "colorize"

class CommandLineInterface
    PROMPT = TTY::Prompt.new
    
    @@user = nil
    @@fight = nil 
    @@enemy = nil

    def run
        title
        player_prompt
        options
    end

    #title graphic and welcome message
    def title
        space
        space
        puts ""
        puts "   ██████╗██╗████████╗██╗   ██╗    ███████╗██╗ ██████╗ ██╗  ██╗████████╗███████╗██████╗ "
        puts "  ██╔════╝██║╚══██╔══╝╚██╗ ██╔╝    ██╔════╝██║██╔════╝ ██║  ██║╚══██╔══╝██╔════╝██╔══██╗"
        puts "  ██║     ██║   ██║    ╚████╔╝     █████╗  ██║██║  ███╗███████║   ██║   █████╗  ██████╔╝"
        puts "  ██║     ██║   ██║     ╚██╔╝      ██╔══╝  ██║██║   ██║██╔══██║   ██║   ██╔══╝  ██╔══██╗"
        puts "  ╚██████╗██║   ██║      ██║       ██║     ██║╚██████╔╝██║  ██║   ██║   ███████╗██║  ██║"
        puts  "  ╚═════╝╚═╝    ╚═╝      ╚═╝       ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝"
        space
        sleep (1)
        PROMPT.ok("Welcome to City Fighter 👊")
        sleep (1)
        space
    end                                                                                      
    
    #Asks if new player or existing user. If new player, calls on sign_up method. If existing user, call on login method
   def player_prompt
        new_player = PROMPT.yes?("Are you a new player?") 
            if new_player == true 
            sign_up
            else 
            login 
        end
        sleep (0.5)
   end
   
    #if user types in a name that exists in the database, they will sign into their user instance. if the name doesn't match, it prompts an error and calls on player_prompt again
   def login
        username = PROMPT.ask("What is your username?", required: true)
        user = existing_user(username)
            if user 
            @@user = user
            else
            PROMPT.error("Player not found.")
            player_prompt   
        end
    end
   
    #helper method to determine whether a user's name already exists in the database
   def existing_user(username)
        Player.find_by(name: username)
   end

   #checks for an existing user, if none is found, a new Player is created with the provided name
   def sign_up
        valid_username = false
        while valid_username == false
        potential_username = PROMPT.ask("What is your name?", required: true)
        already_exists = existing_user(potential_username)
            if already_exists
            valid_username = false
            PROMPT.error("That name is already in use. Please use a different name.")
            else
            valid_username = true
            end
        end 
        create_new_player(potential_username)
    end

    #creates new Player from user input and initialize with 100 health points   
    def create_new_player(username)
       new_player = Player.create(name: username, health: 100)
       @@user = new_player 
    end

    #main menu, provides functionality for options within game
    def options
      selection = PROMPT.select("What would you like to do?") do |menu|
            menu.choice 'Start Fight', 1
            menu.choice 'View Enemy Table', 2
            menu.choice 'View Past Battles', 3
            menu.choice 'Delete Profile', 4
            menu.choice 'Quit', 5
            end
           if selection == 1
            select_opponent
            select_location
            create_fight
            fight
           elsif selection == 2
            select_enemy_bio
           elsif selection == 3
            sleep (0.5)
            @@user.any_fight_history?
            sleep (1)
            @@user.won_and_lost
            sleep (1)
            @@user.win_percent
            sleep (1)
            main_menu
           elsif selection == 4
            sleep (0.5)
            puts "Fine, your profile has been deleted."
            @@user.destroy
            sleep (0.5)
            exit
           else
            sleep (0.5)
            bye
           end
    end

   #opponent selection, used for creating new fight instance by searching enemy name and linking the fight with their enemy_id
    def select_opponent
      enemy = PROMPT.select("Choose your opponent:") do |menu|
        menu.choice 'Bowser'
        menu.choice 'Dementor'
        menu.choice 'The Joker'
        menu.choice 'Lord Voldemort'
        menu.choice 'Michael Myers'
        menu.choice 'Ursula'
        menu.choice 'Go back to main menu'
        end
            if enemy == 'Go back to main menu'
            options
            else
            @@enemy = Enemy.find_by(name: enemy)
        end     
    end

    #displays information from enemy seeds, depending on user's choice, then brings them back to the main menu
    def select_enemy_bio
        enemy = PROMPT.select("Choose an enemy to view:") do |menu|
          menu.choice 'Bowser', 1
          menu.choice 'Dementor', 2
          menu.choice 'The Joker', 3
          menu.choice 'Lord Voldemort', 4
          menu.choice 'Michael Myers', 5
          menu.choice 'Ursula', 6
          menu.choice 'Go back to main menu', 7
         end
            sleep (1)
            if enemy == 1
                bowser = Enemy.find_by(name: "Bowser")
                puts "Name: #{bowser.name}".colorize(:light_blue)
                puts "Creature Type: #{bowser.creature_type}".colorize(:light_cyan)
                puts "Motto: #{bowser.motto}".colorize(:light_magenta)
                main_menu
            elsif enemy == 2
                dementor = Enemy.find_by(name: "Dementor")
                puts "Name: Hoody".colorize(:light_blue)
                puts "Creature Type: #{dementor.creature_type}".colorize(:light_cyan)
                puts "Motto: #{dementor.motto}".colorize(:light_magenta)
                main_menu
            elsif enemy == 3
                joker = Enemy.find_by(name: "The Joker")
                puts "Name: #{joker.name}".colorize(:light_blue)
                puts "Creature Type: #{joker.creature_type}".colorize(:light_cyan)
                puts "Motto: #{joker.motto}".colorize(:light_magenta)
                main_menu
            elsif enemy == 4
                voldemort = Enemy.find_by(name: "Lord Voldemort")
                puts "Name: #{voldemort.name}".colorize(:light_blue)
                puts "Creature Type: #{voldemort.creature_type}".colorize(:light_cyan)
                puts "Motto: #{voldemort.motto}".colorize(:light_magenta)
                main_menu
            elsif enemy == 5
                michael_myers = Enemy.find_by(name: "Michael Myers")
                puts "Name: #{michael_myers.name}".colorize(:light_blue)
                puts "Creature Type: #{michael_myers.creature_type}".colorize(:light_cyan)
                puts "Motto: #{michael_myers.motto}".colorize(:light_magenta)
                main_menu
            elsif enemy == 6
                ursula = Enemy.find_by(name: "Ursula")
                puts "Name: #{ursula.name}".colorize(:light_blue)
                puts "Creature Type: #{ursula.creature_type}".colorize(:light_cyan)
                puts "Motto: #{ursula.motto}".colorize(:light_magenta)
                main_menu
            else
                options
        end
    end

    #helper, waits 2 seconds and brings user back to main menu
    def main_menu
        sleep (2)
        options
    end

    #spaces lines of text
    def space
        puts " "
    end

    #displays location selection, used in creating new fight instance
    def select_location
      @location = PROMPT.select("Choose your battleground:") do |menu|
        menu.choice 'Battery Park'
        menu.choice 'Bryant Park'
        menu.choice 'Central Park'
        menu.choice 'Madison Square Park'
        menu.choice 'Tompkins Square Park'
        menu.choice 'Riverside Park'
        menu.choice 'Washington Square Park'
        menu.choice 'Go back to main menu' 
        end
            if @location == 'Go back to main menu'
                options
            end
     end

    #creates new fight instance with user, chosen enemy, and location
    def create_fight
        @@fight = Fight.create(player_id: @@user.id, enemy_id: @@enemy.id, location: @location)
    end

    #the gameplay - until the last round where player/enemy have health above 0, the enemy and player attack 
    #and their health displays after each round. Depending on whose score is higher in the last round, the 
    #won or lost method will be called
    def fight
        sleep (1)
        space
        puts "Good luck, #{@@user.name}! You've got this in the bag."
        sleep (1)
        space
       while @@user.health > 0 && @@enemy.health > 0 do
        PROMPT.keypress("Press any key to attack")
        enemy_attack
        player_attack
        sleep (0.25)
        puts "-" * 30
        sleep (0.75)
        display_health
        space
      end
      if @@user.health < @@enemy.health
        lost_fight
      else @@user.health > @@enemy.health
        won_fight
      end
    end

    #returns attack to enemy between 15 and 20
    def player_attack
        @@enemy.health -= rand(15..21)
        puts "You attacked #{@@enemy.name}!! ⚔️ ⚔️ ⚔️ ⚔️ ⚔️".colorize(:light_blue)
        sleep (0.5)
    end

    #returns attack to player 
    def enemy_attack
        @@user.health -= rand(15..21)
        puts "#{@@enemy.name} attacked you! 💔 💔 💔 💔 💔".colorize(:light_red)
        sleep (0.5)
     end

    #shows player and enemy's health after each round
    def display_health
        puts "Your current health: #{@@user.health}".colorize(:light_green)
        sleep (0.5)
        puts "#{@@enemy.name}'s current health: #{@@enemy.health}".colorize(:light_magenta)
        sleep (0.5)
    end

    #displays if Player wins fight, updates fight instance for player_won and restores health to 100
    def won_fight
        @@fight.player_won = 1
        @@fight.save
        @@user.health = 100
        @@enemy.health = 100
        puts "Congratulations, you won!".colorize(:green)
        continue
    end

    #displays if Player loses fight, updates fight instance for player_won and restores health to 100
    def lost_fight
        @@fight.player_won = 0
        @@fight.save
        @@user.health = 100
        @@enemy.health = 100
        PROMPT.error("You lost this fight, better luck next time!")
        continue
    end

    #helper method to prompt main menu or quit app
    def continue
        sleep (1)
        yes = PROMPT.yes?("Do you want to continue?")
            if yes == true
            sleep (1)
            space
            puts "Right on 🤟!"
            sleep (1)
            options
            else 
            bye
       end
    end

    #goodbye message
   def bye
    sleep (1)
    space
    puts "Later, loser! ✌️"
    sleep (1)
    space
    exit
   end

end
