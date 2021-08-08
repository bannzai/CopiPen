import CoreData
import Foundation
import UIKit

extension Content {
    enum ContentType {
        case text(String)
        case image(UIImage)
        case url(URL)
        
        // See more details: https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
        var pasteboardType: String {
            switch self {
            case .text:
                return "public.text"
            case .image:
                return "public.jpeg"
            case .url:
                return "public.data"
            }
        }
    }
    
    static func createAndSave(viewContext: NSManagedObjectContext, contentType: ContentType) throws {
        let content = Content(context: viewContext)
        content.id = UUID()
        content.timestamp = Date()
        switch contentType {
        case .text(let text):
            content.text = text
        case .image(let image):
            content.image = image.jpegData(compressionQuality: 1)
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
        if let image = image {
            return .image(image)
        } else if let url = url {
            return .url(url)
        } else if let text = string {
            // Keep order for .text is last.
            // UIPasteboard.text is contained iamge, url
            return .text(text)
        }
        return nil
    }
}
