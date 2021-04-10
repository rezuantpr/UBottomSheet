//
//  BottomSheetDataSource.swift
//  PanModalTest2
//
//  Created by Rezuan Bidzhiev on 10.04.2021.
//

import UIKit

open class BottomSheetDefaultDataSource: UBottomSheetCoordinatorDataSource {
  
  private var sheetPositions: [CGFloat]
  private var availableHeightPercent: CGFloat
  
  public init(sheetPositions: [CGFloat], availableHeightPercent: CGFloat) {
    self.sheetPositions = sheetPositions
    self.availableHeightPercent = availableHeightPercent
  }
  
  public func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
    return sheetPositions.map { availableHeight * $0 }
  }
  
  public func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
    return availableHeight * availableHeightPercent
  }
}
