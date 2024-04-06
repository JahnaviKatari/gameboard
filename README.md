Problem statement : There is a table which has 3 columns and 3 rows as given below
___ ___ ___
SAB H__ S__
___ ___ ___

Where A and B are the players , S is the safe position and H is Home(Final point)
There is dice which has only 3 options i.e (1,2 or 3). Each player rolls the dice alternatively.
The games starts at 2nd row 1st column the players must move in anti-clockwise 
The directions are :
(r,c)=(2,1)->(3,1)->(3,2)->(3,3)->(2,3)->(1,3)->(1,2)->(1,1)->(2,1)->(2,2)[final point]

If A and B are at same position then the current player have to kill other player which means the other player returns to starting safe position i.e (2,1) but if the opponent play is at safe position they we cannot kill the opponent which means both the players stay at the same position
If any of the player reaches the Home point then that print that player as winner
Print the gameboard for each time the player dice

The code for the above problem was return in shell script language
