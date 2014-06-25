//
//  Grid.m
//  GameOfLife
//
//  Created by Johnny Chen on 6/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}

- (void)onEnter
{
    [super onEnter];
    
    [self setupGrid];
    
    // accept touches on the grid
    self.userInteractionEnabled = YES;
}

- (void)setupGrid
{
    // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    // initialize Creatures
    for (int i = 0; i < GRID_ROWS; i++) {
        // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays.
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            // make creatures visible to test this method, remove this once we know we have filled the grid properly
            //creature.isAlive = YES;
            
            x += _cellWidth;
        }
        
        y += _cellHeight;
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //get the x,y coordinate of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    //get the creature at that location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    //invert it's state - kill if it's alive; bring it back to life if it is dead
    creature.isAlive = !creature.isAlive;
}
 
- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition{
    //get the row and column that was touched, return the creature inside
    int row =  touchPosition.y / _cellHeight;
    int column = touchPosition.x / _cellWidth;
    return _gridArray[row][column];
}

- (void)evolveStep
{
    //update each creatre's state
    [self countNeighbors];
    
    //update each creature's state
    [self updateCreatures];
    
    //update the generation so the label's text will display the right generation
    _generation++;
}

- (void)countNeighbors
{
    //iterate through the rows
    //note the NSArray has a method 'count' that will return the number of elements in it
    for (int i = 0; i < [_gridArray count]; i++)
    {
        //iterate through all the columns for a given row
        for (int j = 0; [_gridArray[i] count]; j++)
        {
            //access the creature in the cell that corresponds to the current column/row
            Creature *currentCreature = _gridArray[i][j];
            
            //remember that every creature has a 'living neighbors' property that we created
            currentCreature.livingNeighbors = 0;
            
            //now examine  every cell around the current one
            //go through the row on top of the current cell, the row it is in and the row past the current cell
            for (int x = (i-1);x <= (i+1); x++)
            {
                //go through the column to the left of the current cell, the column it is in and one to the rihgt
                for (int y = (j-1); y <= (j+1); y++)
                {
                    //check to see the cell isn't off the screen
                    BOOL isIndexValid;
                    isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    //skip over all all cells that are off screen and the cell that contains the creature we are currently updating
                    if (!((x == i) && (y == j)) && isIndexValid)
                    {
                        Creature *neighbor = _gridArray[x][y];
                        if(neighbor.isAlive)
                        {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                    
                    
                }
            }
        }
    }
}

- (void)updateCreatures
{
    NSLog(@"updating creatures");
    int numAlive = 0;
    for(int i = 0; i < [_gridArray count]; i++ )
    {
        for(int j = 0; j < [_gridArray[i] count]; j++)
        {
            Creature *currentCreature = _gridArray[i][j];
            if (currentCreature.livingNeighbors == 3) {
                currentCreature.isAlive = TRUE;
                numAlive++;
                NSLog(@"%d,%d",i,j);
            }
            else
                currentCreature.isAlive = FALSE;
        }
    }
    _totalAlive = numAlive;
}

- (BOOL)isIndexValidForX:(int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if (x < 0 || y < 0 || x >= GRID_ROWS || y>=GRID_COLUMNS){
        isIndexValid = NO;
    }
    return isIndexValid;
}
@end
