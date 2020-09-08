//
//  SettingsView.swift
//  Snip
//
//  Created by Anthony Fernandez on 9/7/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  
  @ObservedObject var viewModel: SettingsViewModel
  
  var body: some View {
    ZStack {
      
      backgroundView
      .frame(width: viewModel.size.width, height: viewModel.size.height)
      .transition(AnyTransition.opacity)
      
      VStack(alignment: .leading) {
        Text("Hello")
      }
      .frame(width: viewModel.size.width / 2.5,
             height: viewModel.size.height / 1.5,
             alignment: .center)
      .background(Color.primary)
      .cornerRadius(4.0)
      .offset(x: 0,
              y: viewModel.isVisible ? (( viewModel.size.height / 2) - ((viewModel.size.height / 1.5) / 1.5)) : 10000)
      .transition(AnyTransition.move(edge: .bottom))
      
    }
  }
  
  var backgroundView: some View {
    viewModel.isVisible ? Color.black.opacity(0.8) : Color.clear
  }
}

final class SettingsViewModel: ObservableObject {
  
  var isVisible: Bool
  var size: CGSize
  
  init(isVisible: Bool, readerSize: CGSize) {
    self.isVisible = isVisible
    self.size = readerSize
  }
  
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(viewModel: SettingsViewModel(isVisible: true,
                                              readerSize: CGSize(width: 400,height: 300)))
  }
}
