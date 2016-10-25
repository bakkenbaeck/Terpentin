# Terpentin

[![Version](https://img.shields.io/badge/version-0.0.1-green.svg)](https://github.com/bakkenbaeck/Terpentin/) [![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/bakkenbaeck/Terpentin/blob/master/LICENSE) [![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://github.com/bakkenbaeck/Terpentin)

A Swift wrapper for Safari Reader JavaScript. Still very much a work in progress.

# Usage

Terpentin needs to be a property, so as to prevent it from being deallocated before it's finished.
```swift
self.terpentin = Terpentin()
```

Just call `parse()` with the HTML/Base URL needed. You get back a `ReadableArticle`.

```swift
self.terpentin.parse(html: html, baseURL: url) { article in
    guard let article = article else { return }
    self.title = article.title

    let styledHTML = "<html><head><style>\(css)</style></head><body>\(article.content ?? article.rawContent)</body></html>"
    self.webView.loadHTMLString(styledHTML, baseURL: url)
}
```

Or you can parse straight from a web URL:

```swift
self.terpentin.parse(url: url) { article in
    guard let article = article else { return }
    self.title = article.title

    let styledHTML = "<html><head><style>\(css)</style></head><body>\(article.content ?? article.rawContent)</body></html>"
    self.webView.loadHTMLString(styledHTML, baseURL: url)
}
```