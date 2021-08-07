import SwiftUI
import CoreData

struct PasteboardContentListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Content.timestamp, ascending: true)],
        animation: .default)
    private var contents: FetchedResults<Content>

    var body: some View {
        List {
            ForEach(contents) { content in
                PasteboardContentView(content: content)
            }
            .onDelete(perform: deleteItems)
        }
        .onAppear(perform: {
            deleteAll()
            addItem()
        })
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .active {
                addItem()
            }
        }
    }
    
    private func deleteAll() {
        contents.forEach {
            viewContext.delete($0)
        }
    }
    
    private func addItem() {
        if let contentType = UIPasteboard.general.mapToContentType() {
            withAnimation {
                do {
                    try Content.createAndSave(viewContext: viewContext, contentType: contentType)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { contents[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct PasteboardContentListView_Previews: PreviewProvider {
    static var previews: some View {
        PasteboardContentListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
