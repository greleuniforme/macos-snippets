//
//  ContentView.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/29/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI
import Combine

struct SnipViewApp: View {
  
  @ObservedObject var snippetManager = SnippetManager.shared
  @ObservedObject var viewModel : SnipViewAppViewModel
  @EnvironmentObject var settings: Settings
  
  var body: some View {
    appNavigation
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  var appNavigation: some View {
    GeometryReader { reader in
      ZStack {
        NavigationView {
          
          self.sideBar
          self.openingPanel
        }
        self.settingPanel
          .frame(width: reader.size.width, height: reader.size.height)
        self.addExternalSnipPanel
          .frame(width: reader.size.width, height: reader.size.height)
      }
    }
    .edgesIgnoringSafeArea(.top)
  }
  
  var sideBar: some View {
    Sidebar(viewModel: SideBarViewModel(snipppets: viewModel.snippets, onTrigger: viewModel.trigger(action:)))
      //.visualEffect(material: .sidebar)
      .background(Color.secondary)
      .frame(minWidth: 0, idealWidth: 200, maxWidth: 240)
  }
  
  var openingPanel: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Text("Create your first Snipppet")
          .font(Font.custom("HelveticaNeue-Light", size: 20))
          .foregroundColor(Color.text)
        Spacer()
      }
      HStack {
        Spacer()
        Text("Tips: Cmd+F to search words and regex")
          .font(Font.custom("HelveticaNeue-Light", size: 16))
          .foregroundColor(Color.text)
        Spacer()
      }
      .padding(.top, 8)
      Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.primary)
  }
  
  var settingPanel: some View {
    GeometryReader { reader in
      ZStack {
        
        VStack(alignment: .leading) {
          Text("Hello")
        }
        .frame(width: reader.size.width / 2.5, height: reader.size.height / 1.5, alignment: .center)
        .background(Color.primary)
        .cornerRadius(4.0)
        .offset(x: 0, y: self.snippetManager.hasExternalSnippetQueued ? ((reader.size.height / 2) - ((reader.size.height / 1.5) / 1.5)) : 10000)
        .transition(AnyTransition.move(edge: .bottom))
        
      }
    }
    .background(self.settings.isSettingsOpened ? Color.black.opacity(0.8) : Color.clear)
    .transition(AnyTransition.opacity)
  }
  
  var addExternalSnipPanel: some View {
    GeometryReader { reader in
      ZStack {
        
        VStack(alignment: .leading) {
          VStack {
            TextField("Snippet name", text: .constant(self.snippetManager.tempSnipItem?.name ?? ""))
              .font(Font.custom("HelveticaNeue", size: 20))
              .foregroundColor(.text)
              .frame(maxWidth: .infinity)
              .textFieldStyle(PlainTextFieldStyle())
          }
          .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
          .background(Color.secondary.opacity(0.8))
          
          CodeView(code: .constant(self.snippetManager.tempSnipItem?.snippet ?? ""),
                   mode: .constant(self.snippetManager.tempSnipItem?.mode ?? CodeMode.json.mode()),
                   onContentChange: { newCode in
                    self.snippetManager.tempSnipItem?.snippet = newCode
          })
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
          
          HStack {
            Spacer()
            Button(action: {
              
              withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 40.0, damping: 11, initialVelocity: 0)) { () -> () in
                self.snippetManager.hasExternalSnippetQueued = false
                self.snippetManager.tempSnipItem = nil
              }
            }) {
              Text("Cancel")
                .foregroundColor(.white)
                .padding(4)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.transparent)
            
            Button(action: {}) {
              Text("Add Snippet")
                .foregroundColor(.white)
                .padding(8)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.accent)
            .cornerRadius(4)
          }
        }
        .frame(width: reader.size.width / 2.5, height: reader.size.height / 1.5, alignment: .center)
        .padding()
        .background(Color.primary)
        .cornerRadius(4.0)
        .offset(x: 0, y: self.snippetManager.hasExternalSnippetQueued ? ((reader.size.height / 2) - ((reader.size.height / 1.5) / 1.5)) : 10000)
        .transition(AnyTransition.move(edge: .bottom))
      }
    }
    .background(self.snippetManager.hasExternalSnippetQueued ? Color.black.opacity(0.8) : Color.clear)
    .transition(AnyTransition.opacity)
  }
}


final class SnipViewAppViewModel: ObservableObject {
  
  @Published var snippets: [SnipItem] = []
  
  var cancellables: Set<AnyCancellable> = []
  
  init() {
    SnippetManager
      .shared
      .snipets
      .assign(to: \.snippets, on: self)
      .store(in: &cancellables)
  }
  
  func trigger(action: SnipItemsListAction) {
    SnippetManager.shared.trigger(action: action)
  }
}


struct SnipViewApp_Previews: PreviewProvider {
  static var previews: some View {
    SnipViewApp(viewModel: SnipViewAppViewModel())
  }
}
