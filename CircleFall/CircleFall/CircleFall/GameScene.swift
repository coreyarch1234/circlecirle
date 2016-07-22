//
//  GameScene.swift
//  CircleFall
//
//  Created by Corey Harrilal on 7/11/16.
//  Copyright (c) 2016 coreyarchharrilal. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var gridArray: [[TypeCircle?]] = [[nil, nil, nil, nil], [nil, nil, nil, nil], [nil, nil, nil, nil], [nil, nil, nil, nil]]
    var checkRight: Bool = false
    var checkLeft: Bool = false
    var checkUp: Bool = false
    var checkDown: Bool = false
    //Sum of matching red circles
    
    func respondToSwipeGesture(sender: UIGestureRecognizer) {
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            print("BEFORE")
            for var x in 0...3{
                for var y in 0...3{
                    print(gridArray[x][y] != nil)
                }
            }
            switch swipeGesture.direction {
            
            case UISwipeGestureRecognizerDirection.Right:
                
                print("DONE")
                //Get the location of the swipe
                    let loc = view!.convertPoint(sender.locationInView(view), toScene: self)
                    let node = self.nodeAtPoint(loc)
                    //Check if the node from the swipe is a circle
                    var circle = node as? TypeCircle
                    if circle == nil {
                        //If it is not a circle, check its parent to see if it is
                        circle = node.parent as? TypeCircle
                    }
                    
                    if let circle = circle //Force Unwrap
                    {
                        
                        //Make sure that the circle is not in the last column and that there is nothing to the right of it
                        if circle.xCoord < 3 && (gridArray[circle.xCoord + 1][circle.yCoord] == nil) {
                        
                                gridArray[circle.xCoord][circle.yCoord] = nil
                                gridArray[circle.xCoord + 1][circle.yCoord] = circle
                                circle.position = screenPosition(circle.xCoord + 1, y: circle.yCoord)
                                circle.xCoord += 1
                            
                        }
                        //If there is a circle to the right that is of the same color, create a new circle that has a number that is the sum of the two circles' numbers
                        else if circle.xCoord < 3 && (gridArray[circle.xCoord + 1][circle.yCoord] != nil){
                            //Combine the circles if the circle is not in the top row
                            if (gridArray[circle.xCoord + 1][circle.yCoord]?.color == gridArray[circle.xCoord][circle.yCoord]?.color) && circle.yCoord != 3{
                                let circleNum = gridArray[circle.xCoord + 1][circle.yCoord]!.circleNumber
                                gridArray[circle.xCoord + 1][circle.yCoord]!.removeFromParent()
                                gridArray[circle.xCoord][circle.yCoord] = nil
                                gridArray[circle.xCoord + 1][circle.yCoord] = circle
                                circle.circleNumber = circle.circleNumber + circleNum
                                circle.position = screenPosition(circle.xCoord + 1, y: circle.yCoord)
                                circle.xCoord += 1
                              
                            }
                            //Combine the circles and replace the circle that was moved if the circle is in the top row
                            else if circle.yCoord == 3 && (gridArray[circle.xCoord + 1][circle.yCoord]?.color == gridArray[circle.xCoord][circle.yCoord]?.color) && (gridArray[circle.xCoord + 1][circle.yCoord] != nil){
                                let circleNum = gridArray[circle.xCoord + 1][circle.yCoord]!.circleNumber
                                gridArray[circle.xCoord + 1][circle.yCoord]!.removeFromParent()
                                gridArray[circle.xCoord][circle.yCoord] = nil
                                gridArray[circle.xCoord + 1][circle.yCoord] = circle
                                circle.circleNumber = circle.circleNumber + circleNum
                                circle.position = screenPosition(circle.xCoord + 1, y: circle.yCoord)
                                circle.xCoord += 1
                                
                            }
                        }
                       regenerateIfNeeded()
                       collapseIfNeeded(circle)
                       regenerateIfNeeded()
                    }
                
                
                //collapseIfNeeded(gridArray[circle!.xCoord][circle!.xCoord]!)
                
            case UISwipeGestureRecognizerDirection.Down:
                print("DONE")
                let loc = view!.convertPoint(sender.locationInView(view), toScene: self)
                let node = self.nodeAtPoint(loc)
                var circle = node as? TypeCircle
                if circle == nil {
                    circle = node.parent as? TypeCircle
                }
                
                if let circle = circle
                {
                    if circle.yCoord > 0 && (gridArray[circle.xCoord][circle.yCoord - 1] == nil) {
                        
                        if circle.yCoord == 3{
                            let circlePrevious: TypeCircle = addCircleWithCoordinates(circle.xCoord, y: circle.yCoord)
                            gridArray[circle.xCoord][circle.yCoord] = circlePrevious
                            gridArray[circle.xCoord][circle.yCoord - 1] = circle
                            circle.position = screenPosition(circle.xCoord, y: circle.yCoord - 1)
                            circlePrevious.position = screenPosition(circlePrevious.xCoord, y: circlePrevious.yCoord)
                            circle.yCoord -= 1
                            
                        }
                        else {
                            gridArray[circle.xCoord][circle.yCoord] = nil
                            gridArray[circle.xCoord][circle.yCoord - 1] = circle
                            circle.position = screenPosition(circle.xCoord, y: circle.yCoord - 1)
                            circle.yCoord -= 1
                            
                        }
                    }
                    else if circle.yCoord > 0 && (gridArray[circle.xCoord][circle.yCoord - 1] != nil){
                        if (gridArray[circle.xCoord][circle.yCoord - 1]?.color == gridArray[circle.xCoord][circle.yCoord]?.color) && circle.yCoord != 3{
                            let circleNum = gridArray[circle.xCoord][circle.yCoord - 1]!.circleNumber
                            gridArray[circle.xCoord][circle.yCoord - 1]!.removeFromParent()
                            gridArray[circle.xCoord][circle.yCoord] = nil
                            gridArray[circle.xCoord][circle.yCoord - 1] = circle
                            circle.circleNumber = circle.circleNumber + circleNum
                            circle.position = screenPosition(circle.xCoord, y: circle.yCoord - 1)
                            circle.yCoord -= 1
                            
                        }
                        else if circle.yCoord == 3 && (gridArray[circle.xCoord][circle.yCoord - 1]?.color == gridArray[circle.xCoord][circle.yCoord]?.color) && (gridArray[circle.xCoord][circle.yCoord - 1] != nil){
                            
                            let circleNum = gridArray[circle.xCoord][circle.yCoord - 1]!.circleNumber
                            gridArray[circle.xCoord][circle.yCoord - 1]!.removeFromParent()
                            gridArray[circle.xCoord][circle.yCoord] = nil
                            gridArray[circle.xCoord][circle.yCoord - 1] = circle
                            circle.circleNumber = circle.circleNumber + circleNum
                            circle.position = screenPosition(circle.xCoord, y: circle.yCoord - 1)
                            circle.yCoord -= 1
                            
                        }
                    }
                    regenerateIfNeeded()
                    collapseIfNeeded(circle)
                    regenerateIfNeeded()
                }
                
            case UISwipeGestureRecognizerDirection.Left:
                print("DONE")
                let loc = view!.convertPoint(sender.locationInView(view), toScene: self)
                let node = self.nodeAtPoint(loc)
                var circle = node as? TypeCircle
                if circle == nil {
                    circle = node.parent as? TypeCircle
                }
                
                if let circle = circle
                {
                    if circle.xCoord > 0 && (gridArray[circle.xCoord - 1][circle.yCoord] == nil){
                        
                            gridArray[circle.xCoord][circle.yCoord] = nil
                            gridArray[circle.xCoord - 1][circle.yCoord] = circle
                            circle.position = screenPosition(circle.xCoord - 1, y: circle.yCoord)
                            circle.xCoord -= 1
                        
                    }
                        //If there is a circle to the left of the same color, combine them with the same color and the sum of the numbers
                    else if circle.xCoord > 0 && (gridArray[circle.xCoord - 1][circle.yCoord] != nil){
                        //Combine the circles if the circle is not in the top row
                        if (gridArray[circle.xCoord - 1][circle.yCoord]?.color == gridArray[circle.xCoord][circle.yCoord]?.color) && circle.yCoord != 3{
                            let circleNum = gridArray[circle.xCoord - 1][circle.yCoord]!.circleNumber
                            gridArray[circle.xCoord - 1][circle.yCoord]!.removeFromParent()
                            gridArray[circle.xCoord][circle.yCoord] = nil
                            gridArray[circle.xCoord - 1][circle.yCoord] = circle
                            circle.circleNumber = circle.circleNumber + circleNum
                            circle.position = screenPosition(circle.xCoord - 1, y: circle.yCoord)
                            circle.xCoord -= 1

                        }
                            //Combine the circles and replace the circle that was moved if the circle is in the top row
                        else if circle.yCoord == 3 && (gridArray[circle.xCoord - 1][circle.yCoord]?.color == gridArray[circle.xCoord][circle.yCoord]?.color) && (gridArray[circle.xCoord - 1][circle.yCoord] != nil){
                            let circleNum = gridArray[circle.xCoord - 1][circle.yCoord]!.circleNumber
                            gridArray[circle.xCoord - 1][circle.yCoord]!.removeFromParent()
                            gridArray[circle.xCoord][circle.yCoord] = nil
                            gridArray[circle.xCoord - 1][circle.yCoord] = circle
                            circle.circleNumber = circle.circleNumber + circleNum
                            circle.position = screenPosition(circle.xCoord - 1, y: circle.yCoord)
                            addCircleWithCoordinates(circle.xCoord, y: circle.yCoord) // regenerate
                            circle.xCoord -= 1
                            
                        }
                        
                    }
                    regenerateIfNeeded()
                    collapseIfNeeded(circle)
                    regenerateIfNeeded()
                }
                //collapseIfNeeded(circle!)
            case UISwipeGestureRecognizerDirection.Up:
                print("DONE")
                let loc = view!.convertPoint(sender.locationInView(view), toScene: self)
                let node = self.nodeAtPoint(loc)
                var circle = node as? TypeCircle
                if circle == nil {
                    circle = node.parent as? TypeCircle
                }
                
                if let circle = circle
                {
                    if circle.yCoord < 2 && (gridArray[circle.xCoord][circle.yCoord + 1] == nil){
                        gridArray[circle.xCoord][circle.yCoord] = nil
                        gridArray[circle.xCoord][circle.yCoord + 1] = circle
                        circle.position = screenPosition(circle.xCoord, y: circle.yCoord + 1)
                        circle.yCoord += 1
                    }
                    else if circle.yCoord <= 2 && (gridArray[circle.xCoord][circle.yCoord + 1]?.color == gridArray[circle.xCoord][circle.yCoord]?.color) && (gridArray[circle.xCoord][circle.yCoord + 1] != nil){
                        
                        let circleNum = gridArray[circle.xCoord][circle.yCoord + 1]!.circleNumber
                        gridArray[circle.xCoord][circle.yCoord + 1]!.removeFromParent()
                        gridArray[circle.xCoord][circle.yCoord] = nil
                        gridArray[circle.xCoord][circle.yCoord + 1] = circle
                        circle.circleNumber = circle.circleNumber + circleNum
                        circle.position = screenPosition(circle.xCoord, y: circle.yCoord + 1)
                        circle.yCoord += 1
                        
                    }
                    regenerateIfNeeded()
                    collapseIfNeeded(circle)
                    regenerateIfNeeded()
                }
                //collapseIfNeeded(circle!)
            default:
                break
            }
        }
        
        print("AFTER")
        for var x in 0...3{
            for var y in 0...3{
                print(gridArray[x][y] != nil)
            }
        }
    }
    
    func regenerateIfNeeded(){
        if gridArray[0][3] == nil {
            addCircleWithCoordinates(0, y: 3)
        }
        if gridArray[1][3] == nil{
            addCircleWithCoordinates(1, y: 3)
        }
        if gridArray[2][3] == nil {
            addCircleWithCoordinates(2, y: 3)
        }
        if gridArray[3][3] == nil{
            addCircleWithCoordinates(3, y: 3)
        }
    }

    override func didMoveToView(view: SKView) {
        
        addCircleWithCoordinates(0, y: 3)
        addCircleWithCoordinates(1, y: 3)
        addCircleWithCoordinates(2, y: 3)
        addCircleWithCoordinates(3, y: 3)
        

        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self , action:
            #selector(GameScene.respondToSwipeGesture(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(GameScene.respondToSwipeGesture(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(GameScene.respondToSwipeGesture(_:)))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(GameScene.respondToSwipeGesture(_:)))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
      }

    
    func screenPosition(x: Int, y: Int) -> CGPoint {
        let cellSizeWidth = 155.0
        let cellSizeHeight = 192.0
        let screenX: Double = 89.0 + Double(x) * cellSizeWidth
        let screenY: Double = 301.61 + Double(y) * cellSizeHeight
        return CGPoint(x: screenX, y: screenY)
    }
    
    
    
    func isRow(a: TypeCircle?, b: TypeCircle?, c: TypeCircle?) -> Bool {
        return a?.color == SKColor.redColor() && b?.color == SKColor.redColor() && c?.color == SKColor.redColor()
    }
    
    func collapse(a: TypeCircle, b: TypeCircle, c: TypeCircle, collapseInto: TypeCircle) {
        collapseInto.circleNumber = a.circleNumber + b.circleNumber + c.circleNumber
        if a != collapseInto {
            a.removeFromParent()
            gridArray[a.xCoord][a.yCoord] = nil
        }
        if b != collapseInto {
            b.removeFromParent()
            gridArray[b.xCoord][b.yCoord] = nil
        }
        if c != collapseInto {
            c.removeFromParent()
            gridArray[c.xCoord][c.yCoord] = nil
        }
    }
    
    func collapseRowIfNeeded(x1: Int, y1: Int, x2: Int, y2: Int, x3: Int, y3: Int, collapseInto: TypeCircle) {
        if (isRow(gridArray[x1][y1], b: gridArray[x2][y2], c: gridArray[x3][y3])) {
            collapse(gridArray[x1][y1]!, b: gridArray[x2][y2]!, c: gridArray[x3][y3]!, collapseInto: collapseInto)
        }
    }
    
    func collapseIfNeeded(collapseInto:TypeCircle) {
        
        
        
        // column 0
        collapseRowIfNeeded(0, y1: 0, x2: 0, y2: 1, x3: 0, y3: 2, collapseInto: collapseInto)
        collapseRowIfNeeded(0, y1: 1, x2: 0, y2: 2, x3: 0, y3: 3, collapseInto: collapseInto)
        
        // column 1
        collapseRowIfNeeded(1, y1: 0, x2: 1, y2: 1, x3: 1, y3: 2, collapseInto: collapseInto)
        collapseRowIfNeeded(1, y1: 1, x2: 1, y2: 2, x3: 1, y3: 3, collapseInto: collapseInto)
        
        // column 2
        collapseRowIfNeeded(2, y1: 0, x2: 2, y2: 1, x3: 2, y3: 2, collapseInto: collapseInto)
        collapseRowIfNeeded(2, y1: 1, x2: 2, y2: 2, x3: 2, y3: 3, collapseInto: collapseInto)
        
        // column 3
        collapseRowIfNeeded(3, y1: 0, x2: 3, y2: 1, x3: 3, y3: 2, collapseInto: collapseInto)
        collapseRowIfNeeded(3, y1: 1, x2: 3, y2: 2, x3: 3, y3: 3, collapseInto: collapseInto)
        
    }
   
   override func update(currentTime: CFTimeInterval) {
    
}
    
    func addCircleWithCoordinates(x: Int, y: Int) -> TypeCircle{
        let circleAdd = CircleGenerator.createCircle()
        circleAdd.xCoord = x
        circleAdd.yCoord = y
        circleAdd.position = screenPosition(x, y: y)
        addChild(circleAdd)
        gridArray[x][y] = circleAdd
        return circleAdd
        // create a new circle
        // update the new circle's xCoord and yCoord properties
        // add it to the game scene in the proper position (using screenPosition())
        // add it to gridArray
        
    }
}
    
