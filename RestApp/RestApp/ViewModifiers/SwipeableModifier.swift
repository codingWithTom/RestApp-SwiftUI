//
//  SwipeableModifier.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import SwiftUI

struct SwipeAction {
  let title: String
  let iconName: String
  let onTap: () -> Void
}

struct SwipeableModifier: ViewModifier {
  private let leadingActions: [SwipeAction]
  private let trailingActions: [SwipeAction]
  private let contentHeight: CGFloat
  private var contentWidth: CGFloat { return contentHeight * 0.8 }
  private let leadingColors = [Color.blue, Color.green]
  private let trailingColors = [Color.green, Color.red]
  @State private var offset: CGFloat = 0.0
  @State private var isSlidingFromLeftToRight: Bool = false
  @State private var previousTrailingPoint: CGFloat = 0.0
  
  init(leadingActions: [SwipeAction] = [], trailingActions: [SwipeAction] = [], contentHeight: CGFloat) {
    self.leadingActions = leadingActions
    self.trailingActions = trailingActions
    self.contentHeight = contentHeight
  }
  
  func resetState() {
    withAnimation {
      offset = 0.0
      previousTrailingPoint = 0.0
    }
  }
  
  func body(content: Content) -> some View {
    ZStack {
      HStack(spacing: 0.0) {
        ForEach(0 ..< leadingActions.count, id: \.self) { index in
          let swipeAction = leadingActions[index]
          SwipeActionView(color: leadingColors[index % 2],
                          actionName: swipeAction.title,
                          actionIconName: swipeAction.iconName) {
            swipeAction.onTap()
            self.resetState()
          }
          .frame(width: contentWidth, height: contentHeight)
        }
        Spacer()
        ForEach(0 ..< trailingActions.count, id: \.self) { index in
          let swipeAction = trailingActions[index]
          SwipeActionView(color: trailingColors[index % 2],
                          actionName: swipeAction.title,
                          actionIconName: swipeAction.iconName) {
            swipeAction.onTap()
            self.resetState()
          }
          .frame(width: contentWidth, height: contentHeight)
        }
      }
      content
        .offset(x: offset, y: 0.0)
        .onTapGesture { self.resetState() }
        .gesture(DragGesture()
                  .onChanged { value in
                    let dragOffset: CGFloat
                    isSlidingFromLeftToRight = value.translation.width > 0
                    if isSlidingFromLeftToRight {
                      dragOffset = leadingActions.count > 0 ? value.location.x : 0.0
                    } else {
                      if offset == 0 {
                        self.previousTrailingPoint = value.location.x
                        dragOffset = trailingActions.count > 0 ? value.translation.width : 0.0
                      } else if previousTrailingPoint == 0 {
                        self.previousTrailingPoint = value.location.x
                        dragOffset = offset + value.translation.width
                      } else {
                        dragOffset = offset + value.location.x - previousTrailingPoint
                        previousTrailingPoint = value.location.x
                      }
                    }
                    withAnimation {
                      self.offset = dragOffset
                    }
                  }
                  .onEnded { _ in
                    let finalOffset: CGFloat
                    if isSlidingFromLeftToRight {
                      let distance = min(offset, CGFloat(leadingActions.count) * contentWidth)
                      finalOffset = CGFloat(Int(distance / contentWidth)) * contentWidth
                    } else {
                      let distance = min(-offset, CGFloat(trailingActions.count) * contentWidth)
                      finalOffset = CGFloat(Int(distance / contentWidth)) * contentWidth * -1
                    }
                    
                    withAnimation {
                      self.offset = finalOffset
                      self.previousTrailingPoint = 0.0
                    }
                  }
        )
    }
  }
}

struct SwipeActionView: View {
  let color: Color
  let actionName: String
  let actionIconName: String
  let action: () -> Void
  
  var body: some View {
    ZStack {
      Rectangle().fill(Color.clear)
      VStack(spacing: 4.0) {
        Image(systemName: actionIconName)
        Text(actionName)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action()
    }
    .foregroundColor(.white)
    .background(color)
  }
}

struct SwipeableModifier_Previews: PreviewProvider {
  static var previews: some View {
    let contentHeight: CGFloat = 100
    return Rectangle()
      .fill(Color.gray)
      .modifier(SwipeableModifier(
                  leadingActions: [SwipeAction(title: "Rate", iconName: "star.fill", onTap: {}), SwipeAction(title: "Rate", iconName: "star.fill", onTap: {})],
                  trailingActions: [SwipeAction(title: "Rate", iconName: "star.fill", onTap: {}), SwipeAction(title: "Rate", iconName: "star.fill", onTap: {})],
                  contentHeight: contentHeight))
      .frame(height: contentHeight)
  }
}
