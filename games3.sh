#!/bin/bash

board_size=3
safe_positions=(1 5)
home_position=9
dice_options=(1 2 3)
declare -A current_positions=( ['A']=1 ['B']=1 )
declare -A req_steps=( ['A']=9 ['B']=9 )

display() {
    local a_position=$(( $1 % $home_position ))
    local b_position=$(( $2 % $home_position ))
    declare -A matrix=(
        [0,0]="8___" [0,1]="7___" [0,2]="6___"
        [1,0]="1S__" [1,1]="9H__" [1,2]="5S__"
        [2,0]="2___" [2,1]="3___" [2,2]="4___"
    )

    for ((i = 0; i < 3; i++)); do
        for ((j = 0; j < 3; j++)); do
	    #To check if either of players reaches end point and print the winner with their positions
	    if [[ $a_position -eq 0 || $b_position -eq 0 ]]; then
		    if [[ $a_position -eq 0 ]]; then
			    matrix[1,1]="9HA"
			    echo "Game over!"
		            echo "A Won"
		    else
			    matrix[1,1]="9HB"
                            echo "Game over!"
                            echo "B Won"
		    fi
		    for ((i = 0; i < 3; i++)); do
			    for ((j = 0; j < 3; j++)); do
				    echo -n "${matrix[$i,$j]:1:3} "
                            done
			    echo ""
		    done
                    exit 0

	   #To check if both players are at same safe positions and print SAB
            elif [[ "${matrix[$i,$j]}" == *"$a_position"* ]] && [[ "${matrix[$i,$j]}" == *"$b_position"* ]]; then
                    echo -n "SAB "
                 
           #To check the position of player A with the declared matrix
	    elif [[ "${matrix[$i,$j]}" == *"$a_position"* ]]; then
                
		    #check if players A is at safe positions and print SA
		    if [[ "$a_position" -eq 5 ]] || [[ "$a_position" -eq 1 ]]; then
			    echo -n "SA  "
	            # if not safe print only A
		    else
			    echo -n "A   "
                    fi
            #To check the position of player B with the declared matrix
            elif [[ "${matrix[$i,$j]}" == *"$b_position"* ]]; then
               
		    #check if players A is at safe positions and print SA
	            if [[ "$b_position" -eq 5 ]] || [[ "$b_position" -eq 1 ]]; then
                    
		  	    echo -n "SB  "
	            # if not safe print only A
		    else
			    echo -n "B   "
	            fi
               
            else
                echo -n "${matrix[$i,$j]:1:3} "
            fi
        done
        echo ""
    done
}

#Function to roll the dice
function dice() {
    while true; do
        read -p "Enter dice roll (1, 2, or 3): " choice
        if [[ "$choice" =~ ^[1-3]$ ]]; then
            echo "$choice"
            return
        else
            echo "Invalid input." >&2
        fi
    done
}

move_player() {
    player=$1
    steps=$2

    echo "Moving player $player $steps steps"
    prev_position=${req_steps[$player]}

    # Decrementing the steps
    req_steps[$player]=$(( ${req_steps[$player]} - $steps ))
    echo "The required steps for player $player :${req_steps[$player]}"

    # To check for exceeding case
    if [ ${req_steps[$player]} -lt 0 ]; then
        echo "Player $player exceeded position 9,so remains in current position only"
        req_steps[$player]=$prev_position
    fi

    # To check for safe positions
    if [[ ${req_steps[$player]} -eq 1 || ${req_steps[$player]} -eq 5 ]]; then
        echo "$player is safe."
    fi

    # To check if other players are at the same position (To Kill)
    if [ "$player" == 'A' ]; then
        other_player='B'
    else
        other_player='A'
    fi
    
    if [ ${req_steps[$player]} -eq ${req_steps[$other_player]} ]; then
        if [[ ${req_steps[$player]} -ne 5 && ${req_steps[$player]} -ne 1 ]]; then
             req_steps[$other_player]=9
	     current_positions[$other_player]=1
             echo "$other_player returns to starting safe position."
        fi
    fi

    #To update current position from remaining steps
    if [ ${req_steps[$player]} -eq 0 ]; then
        current_positions[$player]=9
    elif [ ${req_steps[$player]} -eq 1 ]; then
        current_positions[$player]=1
    else
        current_positions[$player]=$((9 - ${req_steps[$player]} + 1))
    fi
    echo "Position of A:${current_positions[A]}   Position of B:${current_positions[B]}"
    # Display the board after moving player
    display "${current_positions[A]}" "${current_positions[B]}"
}


# To START
while true; do
    for player in 'A' 'B'; do
        steps=$(dice)
        move_player $player $steps
    done
done

