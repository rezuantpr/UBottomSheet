//
//  PanelContainer.swift
//  PanModalTest2
//
//  Created by Rezuan Bidzhiev on 10.04.2021.
//

import UIKit

public class PanelContainer<T: UIView>: UIViewController {
  
  public var sheetCoordinator: UBottomSheetCoordinator?
  
  public var dataSource: UBottomSheetCoordinatorDataSource

  private weak var container: UIViewController?
  
  init(container: UIViewController?,
       dataSource: UBottomSheetCoordinatorDataSource = BottomSheetDefaultDataSource(sheetPositions: [0.3, 0.7], availableHeightPercent: 0.7)) {
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
    self.dataSource = BottomSheetDefaultDataSource(sheetPositions: [0.3, 0.7], availableHeightPercent: 0.7)
    super.init(coder: coder)
  }
  
  lazy var innerView = T.init()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .green
    innerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(innerView)
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
    innerView.frame = view.bounds
  }
  
  public override func updateViewConstraints() {
    super.updateViewConstraints()
    innerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    innerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    innerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    innerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
}

extension PanelContainer: Draggable {
  
}

extension PanelContainer: UBottomSheetCoordinatorDelegate {
  
}

extension UIView{
  func roundCorners(corners: UIRectCorner, radius: CGFloat, rect: CGRect) {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
