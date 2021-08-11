import CoreData
import Foundation
import UIKit
import UniformTypeIdentifiers

extension CopiedContent {
    struct Item {
        let key: String
        let preferredKind: Kind
        let allItems: [[String: Any]]

        enum Kind {
            case text(String)
            case image(UIImage)
            case url(URL)
        }
    }

    static func createAndSave(viewContext: NSManagedObjectContext) throws -> CopiedContent? {
        if UIPasteboard.general.items.isEmpty {
            return nil
        }
        if UIPasteboard.general.items.count == 1 && UIPasteboard.general.items.first!.isEmpty {
            // NOTE: If no content on UIPasteboard, it has 1 empty element
            return nil
        }
        let content = CopiedContent(context: viewContext)
        content.id = UUID()
        content.createdDate = Date()
        content.items = UIPasteboard.general.items

        try viewContext.save()

        return content
    }
    
    var preferredContentItem: Item? {
        guard let items = items else {
            return nil
        }
        return items.flatMap { dictionary in
            return dictionary.keys.compactMap { key -> Item? in
                guard let utType = UTType(key) else {
                    return nil
                }
                guard let value = dictionary[key] else {
                    return nil
                }
                if utType.conforms(to: .image) {
                    if let data = value as? Data, let image = UIImage(data: data) {
                        return Item(key: key, preferredKind: .image(image), allItems: items)
                    }
                    if let image = value as? UIImage {
                        return Item(key: key, preferredKind: .image(image), allItems: items)
                    }
                }
                if utType.conforms(to: .url) {
                    if let url = value as? URL {
                        return Item(key: key, preferredKind: .url(url), allItems: items)
                    }
                }
                if utType.conforms(to: .text) {
                    if let text = value as? String {
                        return Item(key: key, preferredKind: .text(text), allItems: items)
                    }
                }
                return nil
            }
        }
        .first
    }
}
