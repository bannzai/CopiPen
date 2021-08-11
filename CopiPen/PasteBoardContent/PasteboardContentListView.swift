import SwiftUI
import CoreData

struct PasteboardContentListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CopiedContent.createdDate, ascending: false)],
        animation: .default)
    private var contents: FetchedResults<CopiedContent>
    @State private var shownCopiedToast: Bool = false
    @State private var shownUndoToast: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(contents) { content in
                        PasteboardContentView(content: content, onPaste: { contentType in
                            withAnimation {
                                shownCopiedToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        shownCopiedToast = false
                                    }
                                }
                            }
                        })
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                .onAppear(perform: {
                    addItem()
                })
                .onChange(of: scenePhase) { scenePhase in
                    if scenePhase == .active {
                        addItem()
                    }
                }
            }
            .navigationTitle("Copied List")
            .toast(isPresented: $shownCopiedToast) {
                VStack {
                    Spacer()
                    Toast(text: "コピーしました")
                }
            }
            .toast(isPresented: $shownUndoToast) {
                VStack {
                    Spacer()
                    Button(action: {
                        deleteItems(offsets: .init(integersIn: 0..<1))
                        shownUndoToast = false
                    }, label: {
                        Toast(text: "ペーストを取り消す")
                    })
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            do {
                try CopiedContent.createAndSave(viewContext: viewContext)
                shownUndoToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    shownUndoToast = false
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
            .environment(\.colorScheme, .dark)

    }
}
