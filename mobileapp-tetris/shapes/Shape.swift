//
//  Shape.swift
//  tetris
//
//  Created by Khim Bahadur Gurung on 17.01.18.
//  Copyright © 2018 Khim Bahadur Gurung. All rights reserved.
//
import SpriteKit

let NumOrientations: UInt32 = 4

let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

enum Orientation: Int, CustomStringConvertible {
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    
    static func random() -> Orientation {
        return Orientation(rawValue:Int(arc4random_uniform(NumOrientations)))!
    }
    
    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue:rotated)!
    }
}

class Shape: Hashable, CustomStringConvertible {
    
    let block:String

    var blocks = Array<Block>()

    var face: Orientation

    var column, row:Int
    
    //override by shape subclass
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    //override by shape subclass
    var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [:]
    }

    var bottomBlocks:Array<Block> {
        guard let bottomBlocks = bottomBlocksForOrientations[face] else {
            return []
        }
        return bottomBlocks
    }
    

    var hashValue:Int {

        return blocks.reduce(0) { $0.hashValue ^ $1.hashValue }
    }
    

    var description:String {
        return "\(block) block facing \(face): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    init(column:Int, row:Int, orientation:Orientation) {
        self.block = "red"
        self.column = column
        self.row = row
        self.face = orientation
        initializeBlocks()
        
    }

    convenience init(column:Int, row:Int) {
        self.init(column:column, row:row, orientation:Orientation.random())
    }
    
    final func initializeBlocks() {
        guard let blockRowColumnTranslations = blockRowColumnPositions[face] else {
            return
        }
        blocks = blockRowColumnTranslations.map { (diff) -> Block in
            return Block(column: column + diff.columnDiff, row: row + diff.rowDiff, color:blockColor)
        }
    }
    
    final func rotateBlocks(orientation: Orientation) {
        guard let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] else {
            return
        }
        for (idx, diff) in blockRowColumnTranslation.enumerated() {
            blocks[idx].column = column + diff.columnDiff
            blocks[idx].row = row + diff.rowDiff
        }
    }
    
    final func lowerShapeByOneRow() {
        shiftBy(columns: 0, rows:1)
    }
    
    final func raiseShapeByOneRow() {
       shiftBy(columns: 0, rows:-1)
    }
    
    final func shiftRightByOneColumn() {
        shiftBy(columns: 1, rows:0)
    }
    
    final func shiftLeftByOneColumn() {
        shiftBy(columns: -1, rows:0)
    }
    
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    
    final func moveTo(column: Int, row:Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation: face)
    }
    
    final class func random(startingColumn:Int, startingRow:Int) -> Shape {
        switch Int(arc4random_uniform(5)) {
        case 0:
            return SquareShape(column:startingColumn, row:startingRow)
        case 1:
            return LineShape(column:startingColumn, row:startingRow)
        case 2:
            return TShape(column:startingColumn, row:startingRow)
        case 3:
            return LShape(column:startingColumn, row:startingRow)
        case 4:
            return JShape(column:startingColumn, row:startingRow)
        case 5:
            return SShape(column:startingColumn, row:startingRow)
        default:
            return ZShape(column:startingColumn, row:startingRow)
        }
    }
    
    final func rotateClockwise() {
        let newOrientation = Orientation.rotate(orientation: face, clockwise: true)
        rotateBlocks(orientation: newOrientation)
        face = newOrientation
    }
    final func rotateAnticlockwise() {
        let newOrientation = Orientation.rotate(orientation: face, clockwise: false)
        rotateBlocks(orientation: newOrientation)
        face = newOrientation
    }
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}

