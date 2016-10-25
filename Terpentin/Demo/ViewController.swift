import UIKit
import SweetUIKit
import Terpentin

class ViewController: UIViewController {
    var isContentStripped = false

    lazy var terpentin: Terpentin = {
        return Terpentin()
    }()

    lazy var webView: UIWebView = {
        let view = UIWebView(withAutoLayout: true)
        view.delegate = self

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.webView)
        self.webView.fillSuperview()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let url = Bundle(for: self.classForCoder).url(forResource: "Test", withExtension: "html")!
        let html = try! String(contentsOf: url)
        let css = try! String(contentsOf: Bundle(for: self.classForCoder).url(forResource: "Test", withExtension: "css")!)

        self.terpentin.parse(html: html, baseURL: url) { article in
            guard let article = article else { return }
            self.title = article.title

            let styledHTML = "<html><head><style>\(css)</style></head><body>\(article.content ?? article.rawContent)</body></html>"
            self.webView.loadHTMLString(styledHTML, baseURL: url)
        }
    }
}

extension ViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard !self.isContentStripped else { return }
    }
}
