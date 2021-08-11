import CoreData
import Foundation
import UIKit
import UniformTypeIdentifiers

extension CopiedContent {
    struct Item {
        let key: String
        let preferredKind: ContentKind
        let allItems: [[String: Any]]

        enum ContentKind {
            case text(String)
            case image(UIImage)
            case url(URL)
        }
    }

    static func createAndSave(viewContext: NSManagedObjectContext) throws {
        let content = CopiedContent(context: viewContext)
        content.id = UUID()
        content.createdDate = Date()
        content.items = UIPasteboard.general.items

        try viewContext.save()
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
                if utType.conforms(to: .image) {
                    guard let value = dictionary[key] else {
                        return nil
                    }
                    if let data = value as? Data, let image = UIImage(data: data) {
                        return Item(key: key, preferredKind: .image(image), allItems: items)
                    }
                    if let image = value as? UIImage {
                        return Item(key: key, preferredKind: .image(image), allItems: items)
                    }
                    return nil
                }
                if utType.conforms(to: .url) {
                    guard let value = dictionary[key], let url = value as? URL else {
                        return nil
                    }
                    return Item(key: key, preferredKind: .url(url), allItems: items)
                }
                if utType.conforms(to: .text) {
                    guard let value = dictionary[key], let text = value as? String else {
                        return nil
                    }
                    return Item(key: key, preferredKind: .text(text), allItems: items)
                }
                return nil
            }
        }
        .first
    }
}
