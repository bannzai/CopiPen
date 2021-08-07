//
//  ContentView.swift
//  CopiPen
//
//  Created by 廣瀬雄大 on 2021/08/07.
//

import SwiftUI
import CoreData

struct Content: Identifiable {
    let id = UUID()
    let text: String?
    let image: UIImage?
    init(text: String) {
        self.text = text
        self.image = nil
    }
    init(image: UIImage) {
        self.text = nil
        self.image = image
    }
}

final class ContentViewModel: ObservableObject {
    @Published var items: [Content] = []
    
    func update() {
        if let image = UIPasteboard.general.image {
            items.append(.init(image: image))
        } else if let text = UIPasteboard.general.string {
            items.append(.init(text: text))
        }
    }
}

struct ContentView: View {
    @ObservedObject private var viewModel: ContentViewModel = .init()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        List {
            ForEach(viewModel.items) { content in
                if let text = content.text {
                    Text("Text at \(text)")
                }
                if let image = content.image {
                    Image(uiImage: image)
                }
            }
        }
        .onAppear(perform: {
            print("onAppear")
            viewModel.update()
        })
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .active {
                viewModel.update()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
