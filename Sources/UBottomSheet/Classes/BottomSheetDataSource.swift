//
//  BottomSheetDataSource.swift
//  PanModalTest2
//
//  Created by Rezuan Bidzhiev on 10.04.2021.
//

import UIKit

open class BottomSheetDefaultDataSource: UBottomSheetCoordinatorDataSource {
  
  private var sheetPositions: [CGFloat]
  private var initialPosition: CGFloat
  
  public init(sheetPositions: [CGFloat], initialPosition: CGFloat) {
    self.sheetPositions = sheetPositions
    self.initialPosition = initialPosition
  }
  
  public func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
    return sheetPositions.map { availableHeight * $0 }
  }
  
  public func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
    return availableHeight * initialPosition
  }
}
