import CoreData
import Foundation
import UIKit

extension Content {
    enum ContentType {
        case text(String)
        case image(UIImage)
        case url(URL)
    }

    static func createAndSave(viewContext: NSManagedObjectContext, contentType: ContentType) throws {
        let content = Content(context: viewContext)
        content.id = UUID()
        content.timestamp = Date()
        switch contentType {
        case .text(let text):
            content.text = text
        case .image(let image):
            content.image = image.jpegData(compressionQuality: 0.7)
        case .url(let url):
            content.url = url
        }

        try viewContext.save()
    }
    
    var contentType: ContentType? {
        if let text = text {
            return .text(text)
        } else if let image = image, let uiImage = UIImage(data: image) {
            return .image(uiImage)
        } else if let url = url {
            return .url(url)
        }
        return nil
    }
}

extension UIPasteboard {
    func mapToContentType() -> Content.ContentType? {
        if let text = string {
            return .text(text)
        } else if let image = image {
            return .image(image)
        } else if let url = url {
            return .url(url)
        }

        return nil
    }
}
