import SwiftUI
import CoreData

struct PasteboardContentListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CopiedContent.createdDate, ascending: false)],
        animation: .default)
    private var contents: FetchedResults<CopiedContent>
    @State private var shownCopiedToast = false
    @State private var shownUndoToast = false
    @State private var isDeleteAllDialogPresented = false
    @State private var alertError: AlertError?

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
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isDeleteAllDialogPresented = true }, label: {
                        Image(systemName: "trash")
                    })
                }
            })
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
            .background(
                EmptyView()
                    .alert(isPresented: $isDeleteAllDialogPresented) {
                        Alert(
                            title: Text("すべて削除します"),
                            message: Text("削除したデータは復元できません"),
                            primaryButton: .default(Text("削除する"), action: deleteAll),
                            secondaryButton: .cancel()
                        )
                    }
            )
            .background(
                EmptyView()
                    .errorAlert(error: $alertError)
            )
        }
    }
    
    private func addItem() {
        withAnimation {
            do {
                if let _ = try CopiedContent.createAndSave(viewContext: viewContext) {
                    shownUndoToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        shownUndoToast = false
                    }
                }
            } catch {
                alertError = .init(kind: .delete, error: .init(error: error))
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { contents[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                alertError = .init(kind: .delete, error: .init(error: error))
            }
        }
    }
    
    private func deleteAll() {
        contents.forEach(viewContext.delete)

        do {
            try viewContext.save()
        } catch {
            alertError = .init(kind: .delete, error: .init(error: error))
        }
    }
}

struct PasteboardContentListView_Previews: PreviewProvider {
    static var previews: some View {
        PasteboardContentListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environment(\.colorScheme, .dark)

    }
}
