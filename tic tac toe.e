
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

char board[9];
int humanWins = 0;
int aiWins = 0;
int draws = 0;

// Reset the board
void resetBoard()
{
    for(int i = 0; i < 9; i++)
        board[i] = '1' + i;
}

// Display the board
void displayBoard()
{
    printf("\n");
    printf("       TIC TAC TOE\n\n");

    printf("        %c | %c | %c\n", board[0], board[1], board[2]);
    printf("       ---|---|---\n");
    printf("        %c | %c | %c\n", board[3], board[4], board[5]);
    printf("       ---|---|---\n");
    printf("        %c | %c | %c\n", board[6], board[7], board[8]);

    printf("\n");
}

// Check winner
char checkWinner()
{
    int win[8][3] = {
        {0,1,2}, {3,4,5}, {6,7,8},
        {0,3,6}, {1,4,7}, {2,5,8},
        {0,4,8}, {2,4,6}
    };

    for(int i = 0; i < 8; i++)
    {
        int a = win[i][0];
        int b = win[i][1];
        int c = win[i][2];

        if(board[a] == board[b] && board[b] == board[c])
            return board[a];
    }

    return ' ';
}

// Check if board is full
int isDraw()
{
    for(int i = 0; i < 9; i++)
    {
        if(board[i] != 'X' && board[i] != 'O')
            return 0;
    }

    return 1;
}

// Check if a position is empty
int isEmpty(int position)
{
    return board[position] != 'X' && board[position] != 'O';
}

// Make a random move
int randomMove()
{
    int moves[9];
    int count = 0;

    for(int i = 0; i < 9; i++)
    {
        if(isEmpty(i))
            moves[count++] = i;
    }

    if(count == 0)
        return -1;

    return moves[rand() % count];
}

// Find a winning or blocking move
int findWinningMove(char mark)
{
    for(int i = 0; i < 9; i++)
    {
        if(isEmpty(i))
        {
            char old = board[i];
            board[i] = mark;

            if(checkWinner() == mark)
            {
                board[i] = old;
                return i;
            }

            board[i] = old;
        }
    }

    return -1;
}

// Easy difficulty
int easyAI()
{
    return randomMove();
}

// Medium difficulty
int mediumAI()
{
    int move;

    // Try to win
    move = findWinningMove('O');
    if(move != -1)
        return move;

    // Block the player
    move = findWinningMove('X');
    if(move != -1)
        return move;

    // Take center
    if(isEmpty(4))
        return 4;

    // Take a corner
    int corners[] = {0, 2, 6, 8};

    for(int i = 0; i < 4; i++)
    {
        if(isEmpty(corners[i]))
            return corners[i];
    }

    return randomMove();
}

// Minimax algorithm
int minimax(int isMaximizing)
{
    char result = checkWinner();

    if(result == 'O')
        return 10;

    if(result == 'X')
        return -10;

    if(isDraw())
        return 0;

    if(isMaximizing)
    {
        int bestScore = -1000;

        for(int i = 0; i < 9; i++)
        {
            if(isEmpty(i))
            {
                char old = board[i];
                board[i] = 'O';

                int score = minimax(0);

                board[i] = old;

                if(score > bestScore)
                    bestScore = score;
            }
        }

        return bestScore;
    }
    else
    {
        int bestScore = 1000;

        for(int i = 0; i < 9; i++)
        {
            if(isEmpty(i))
            {
                char old = board[i];
                board[i] = 'X';

                int score = minimax(1);

                board[i] = old;

                if(score < bestScore)
                    bestScore = score;
            }
        }

        return bestScore;
    }
}

// Hard difficulty
int hardAI()
{
    int bestScore = -1000;
    int bestMove = -1;

    for(int i = 0; i < 9; i++)
    {
        if(isEmpty(i))
        {
            char old = board[i];
            board[i] = 'O';

            int score = minimax(0);

            board[i] = old;

            if(score > bestScore)
            {
                bestScore = score;
                bestMove = i;
            }
        }
    }

    return bestMove;
}

// AI makes a move
void computerMove(int difficulty)
{
    int move;

    printf("\nComputer is thinking...\n");

    if(difficulty == 1)
        move = easyAI();
    else if(difficulty == 2)
        move = mediumAI();
    else
        move = hardAI();

    if(move != -1)
    {
        board[move] = 'O';
        printf("Computer selected position %d!\n", move + 1);
    }
}

// Display scoreboard
void displayScore()
{
    printf("\n========== SCOREBOARD ==========\n");
    printf("Your Wins       : %d\n", humanWins);
    printf("Computer Wins   : %d\n", aiWins);
    printf("Draws           : %d\n", draws);
    printf("================================\n");
}

// Main function
int main()
{
    int difficulty;
    int position;
    char playAgain;

    srand((unsigned int)time(NULL));

    printf("\n====================================\n");
    printf("       TIC TAC TOE VS AI\n");
    printf("====================================\n");

    printf("\nSelect Difficulty:\n");
    printf("1. Easy\n");
    printf("2. Medium\n");
    printf("3. Hard\n");

    do
    {
        printf("\nEnter difficulty (1-3): ");

        if(scanf("%d", &difficulty) != 1)
        {
            printf("Invalid input!\n");

            int ch;
            while((ch = getchar()) != '\n' && ch != EOF);
            difficulty = 0;
            continue;
        }

        if(difficulty < 1 || difficulty > 3)
            printf("Choose between 1 and 3!\n");

    } while(difficulty < 1 || difficulty > 3);

    do
    {
        resetBoard();

        while(1)
        {
            displayBoard();

            printf("Your turn (X).\n");
            printf("Enter position (1-9): ");

            if(scanf("%d", &position) != 1)
            {
                printf("Please enter a valid number!\n");

                int ch;
                while((ch = getchar()) != '\n' && ch != EOF);
                continue;
            }

            if(position < 1 || position > 9)
            {
                printf("Invalid position! Try again.\n");
                continue;
            }

            if(!isEmpty(position - 1))
            {
                printf("Position already occupied!\n");
                continue;
            }

            board[position - 1] = 'X';

            if(checkWinner() == 'X')
            {
                displayBoard();
                printf("\nCongratulations! YOU WIN!\n");
                humanWins++;
                break;
            }

            if(isDraw())
            {
                displayBoard();
                printf("\nIt's a DRAW!\n");
                draws++;
                break;
            }

            computerMove(difficulty);

            if(checkWinner() == 'O')
            {
                displayBoard();
                printf("\nCOMPUTER WINS! Better luck next time!\n");
                aiWins++;
                break;
            }

            if(isDraw())
            {
                displayBoard();
                printf("\nIt's a DRAW!\n");
                draws++;
                break;
            }
        }

        displayScore();

        printf("\nDo you want to play again? (Y/N): ");
        scanf(" %c", &playAgain);

    } while(playAgain == 'Y' || playAgain == 'y');

    printf("\nThanks for playing TIC TAC TOE!\n");
    printf("Final Score:\n");
    displayScore();

    return 0;
}
