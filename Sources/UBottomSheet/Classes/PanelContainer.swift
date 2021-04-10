//
//  PanelContainer.swift
//  PanModalTest2
//
//  Created by Rezuan Bidzhiev on 10.04.2021.
//

import UIKit

public enum PanelPosition {
  case top
  case bottom
}

public protocol PanelContainerDelegate: class {
  func didChange(position: PanelPosition)
}

public class PanelContainer<T: UIView>: UIViewController {
  
  public weak var delegate: PanelContainerDelegate?
  
  public var sheetCoordinator: UBottomSheetCoordinator?
  
  public var dataSource: UBottomSheetCoordinatorDataSource

  private weak var container: UIViewController?
  
  public init(container: UIViewController?,
       dataSource: UBottomSheetCoordinatorDataSource = BottomSheetDefaultDataSource(sheetPositions: [0.3, 0.7], initialPosition: 0.7)) {
    self.dataSource = dataSource
    super.init(nibName: nil, bundle: nil)
    
    self.container = container
    if let parent = container {
      sheetCoordinator = UBottomSheetCoordinator(parent: parent)
      sheetCoordinator?.dataSource = dataSource
      sheetCoordinator?.delegate = self
    }
  }
  
  required public init?(coder: NSCoder) {
    self.dataSource = BottomSheetDefaultDataSource(sheetPositions: [0.3, 0.7], initialPosition: 0.7)
    super.init(coder: coder)
  }
  
  public lazy var childView = T.init()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    childView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(childView)
    view.setNeedsUpdateConstraints()
  }
  
  public func show() {
    
    guard let parent = container else { return }
    
    sheetCoordinator?.addSheet(self, to: parent) { container in
      let f = parent.view.frame
      let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
      container.roundCorners(corners: [.topLeft, .topRight], radius: 20, rect: rect)
    }
    
    sheetCoordinator?.setCornerRadius(20)
  }
  
  public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      sheetCoordinator?.startTracking(item: self)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    childView.frame = view.bounds
  }
  
  public override func updateViewConstraints() {
    super.updateViewConstraints()
    childView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    childView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    childView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    childView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
}

extension PanelContainer: Draggable {
  
}

extension PanelContainer: UBottomSheetCoordinatorDelegate {
  public func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
    switch state {

    case .finished(_, let percent):
      let sheetPositions = dataSource.sheetPositions(sheetCoordinator?.availableHeight ?? 0)
      if abs(percent - (sheetPositions.first ?? 0)) < 0.001 {
        delegate?.didChange(position: .top)
      } else if abs(percent - (sheetPositions.last ?? 0)) < 0.001 {
        delegate?.didChange(position: .bottom)
      }
      break
      
    default: break
    }
  }
}

extension UIView{
  func roundCorners(corners: UIRectCorner, radius: CGFloat, rect: CGRect) {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
