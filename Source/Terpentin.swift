import Foundation
import UIKit
import JavaScriptCore

open class Terpentin: NSObject {

    var html: String!

    fileprivate var isParsingFromURL = false

    fileprivate var completion: ((_ article: ReadableArticle?) -> ())?

    lazy var webView: UIWebView = {
        let view = UIWebView()
        view.delegate = self

        return view
    }()

    lazy var context: JSContext = {
        guard let context = self.webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else { fatalError("Could not get JSContext from web view.") }

        return context
    }()

    lazy var readerSource: String = {
        try! String(contentsOfFile: Bundle(for: self.classForCoder).path(forResource: "reader", ofType: "js")!)
    }()

    public func parse(html: String, baseURL: URL, completion: @escaping((_ article: ReadableArticle?) -> ())) {
        self.isParsingFromURL = false
        self.html = html
        self.completion = completion
        self.webView.loadHTMLString(html, baseURL: baseURL)
    }

    public func parse(url: URL, completion: @escaping((_ article: ReadableArticle?) -> ())) {
        self.isParsingFromURL = true
        self.completion = completion
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
    }

    deinit {
        self.webView.removeFromSuperview()
    }
}

extension Terpentin: UIWebViewDelegate {
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.isParsingFromURL {
            self.html = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
        }

        context.evaluateScript(self.readerSource)
        context.evaluateScript("var ReaderArticleFinderJS = new ReaderArticleFinder(document);")
        context.evaluateScript("ReaderArticleFinderJS.prepareToTransitionToReader();")

        let isReaderModeAvailable = context.evaluateScript("ReaderArticleFinderJS.isReaderModeAvailable();").toBool()
        let nextPageURL = URL(string: context.evaluateScript("ReaderArticleFinderJS.nextPageURL();").toString())
        let isLTR = context.evaluateScript("ReaderArticleFinderJS.articleIsLTR();").toBool()
        let isWiki = context.evaluateScript("ReaderArticleFinderJS.isMediaWikiPage();").toBool()
        let isWordpress = context.evaluateScript("ReaderArticleFinderJS.isWordPressSite();").toBool()

        let title = context.evaluateScript("ReaderArticleFinderJS.articleTitle();").toString()
        let content = context.evaluateScript("ReaderArticleFinderJS.articleNode().outerHTML;").toString()
        let plainText = context.evaluateScript("ReaderArticleFinderJS.articleTextContent();").toString()

        let article = ReadableArticle(title: title, content: content!, rawContent: self.html, isReaderModeAvailable: isReaderModeAvailable, nextPageURL: nextPageURL, isLTR: isLTR, isMediaWiki: isWiki, isWordpress: isWordpress)

        self.completion?(article)
    }
}
