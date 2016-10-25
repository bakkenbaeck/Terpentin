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

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Local", style: .plain, target: self, action: #selector(loadLocal))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Remote", style: .plain, target: self, action: #selector(loadRemote))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadLocal()
    }

    func loadLocal() {
        let css = try! String(contentsOf: Bundle(for: self.classForCoder).url(forResource: "Test", withExtension: "css")!)
        let url = Bundle(for: self.classForCoder).url(forResource: "Test", withExtension: "html")!
        let html = try! String(contentsOf: url)

        self.terpentin.parse(html: html, baseURL: url) { article in
            guard let article = article else { return }
            self.title = "Local"
            let title = article.title ?? ""
            let styledHTML = "<html><head><style>\(css)</style><title>\(title)</title></head><body><h1>\(title)</h1>\(article.content ?? article.rawContent)</body></html>"
            self.webView.loadHTMLString(styledHTML, baseURL: url)
        }
    }

    func loadRemote() {
        let css = try! String(contentsOf: Bundle(for: self.classForCoder).url(forResource: "Test", withExtension: "css")!)
        let url = URL(string: "http://blog.manbolo.com/2013/03/18/safari-reader-source-code")!

        self.terpentin.parse(url: url) { article in
            guard let article = article else { return }
            self.title = "Remote"
            let title = article.title ?? ""
            let styledHTML = "<html><head><style>\(css)</style><title>\(title)</title></head><body><h1>\(title)</h1>\(article.content ?? article.rawContent)</body></html>"
            self.webView.loadHTMLString(styledHTML, baseURL: url)
        }
    }
}

extension ViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard !self.isContentStripped else { return }
    }
}
