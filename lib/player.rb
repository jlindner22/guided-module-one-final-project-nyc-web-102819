require "tty-prompt"
require 'pry'

class Player < ActiveRecord::Base
    has_many :fights
    has_many :enemies, through: :fights

    PROMPT = TTY::Prompt.new

    #helper method to tell player what fights they have been in
    def my_fights
        Fight.all.select do |fights|
            fights.player_id == self.id
        end
    end

    #helper method for win percentage
    def my_fights_count
        my_fights.count
    end

    #depending on player fight history, displays fight history or error message
    def any_fight_history?
       if self.my_fights.length < 1
       puts "You have no previous battles. Go back to the main menu and select 'Start Fight' to add to your history."
        else
            my_fights.each do |fights|
               puts "You battled #{Enemy.find(fights.enemy_id).name}, a #{Enemy.find(fights.enemy_id).creature_type}. You #{won?(fights)}!"
            end
        end
    end
    
    #helper method to determine fight history message outcome
    def won?(fight)
        if fight.player_won == true
            "won"
        else
            "lost"
        end
    end

    #helper method to grab outcomes of all fights for that player
    def fight_outcomes
        my_fights.pluck(:player_won)
    end

    #helper method to grab only fights that were won by the player
    def won_fights
        fight_outcomes.select do |fights|
        fights == true
        end
    end

    #displays numbers of player's fights won out of their total, blank if no fight history
     def won_and_lost
        if my_fights_count > 0
            puts "You've won #{won_fights_count} out of #{my_fights_count} fights."
            else
            puts ""
        end
     end

    #works, gets count of fights won by player
    def won_fights_count
        won_fights.count
    end

    #works, displays percent of wins
    def win_percent
       fraction = won_fights_count.to_f / my_fights_count.to_f
       total = fraction * 100
       percentage = "#{total.round(2)}%"
            if total >= 75.00
            PROMPT.ok("Great job, champ! Your win percentage is #{percentage} 🙌")
            elsif total > 1
            PROMPT.error("Better practice some more, loser! Your win percentage is #{percentage} 👎")
            else
            puts "Get in the ring and fight!"
            end
    end

end