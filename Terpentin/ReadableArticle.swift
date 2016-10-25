import Foundation

open class ReadableArticle {
    public var title: String?
    public var isReaderModeAvailable: Bool = false
    public var nextPageURL: URL?

    public var isLTR: Bool = true
    public var isMediaWikiPage: Bool = false
    public var isWordpressSite: Bool = false

    public var articleTitle: String?
    public var content: String?
    public var rawContent: String

    public init(title: String?, content: String, rawContent: String, isReaderModeAvailable: Bool, nextPageURL: URL? = nil, isLTR: Bool = true, isMediaWiki: Bool = false, isWordpress: Bool = false) {
        self.isReaderModeAvailable = isReaderModeAvailable

        self.title = title
        self.nextPageURL = nextPageURL

        self.isLTR = isLTR
        self.isMediaWikiPage = isMediaWiki
        self.isWordpressSite = isWordpress

        self.articleTitle = title
        self.content = content
        self.rawContent = rawContent
    }
}
