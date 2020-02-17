//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var videos = [YoutubeVideo]()
    var lastContentOffset: CGFloat = 0.0
    var datas:[String] = [
        "https://drive.google.com/open?id=1MkhjK7VoZleg27t1R_EDMIWohNdhzr3r",
        "https://drive.google.com/open?id=1HWsp0aE7_ikWkaRd4Fs_aGS9-sxAKgcc",
        "https://drive.google.com/open?id=1wJ9G0mgzsxhYOqN51cV2nYgUl3fCWUy5",
        "https://drive.google.com/open?id=1UWqUIHK7RwKh3_xTkVwM0U3k_w0OTvZf",
        "https://drive.google.com/open?id=1okdGH5MA2WCkMa_p-GDp57LdGsCoFHSt",
        "https://drive.google.com/open?id=1kIj2AGax1U_3w9Sf79g4Hkb_06SGL5wV",
        "https://drive.google.com/open?id=1dGKNTey2SMlR7hjlCiXeL1H49ETIbCIh",
        "https://drive.google.com/open?id=1pnTv4DYBEQEstV5izMehOPiyyMcnF2F0",
        "https://drive.google.com/open?id=11No6Vxhg01-u-nBmaNCdgTqeByJcSa3p",
        "https://drive.google.com/open?id=1YQXfjVFc4fVjg3vlvBKVv35aaPwc9lXF",
    ]
    //MARK: Methods
    func customization() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.alwaysBounceHorizontal = false
        self.tableView.estimatedRowHeight = 300
        self.tableView.snp.makeConstraints{ m in
            m.bottom.equalToSuperview()
            m.top.equalToSuperview().offset(xTopOffset + 44)
            m.width.equalTo(self.view.bounds.width - 32)
            m.centerX.equalToSuperview()
        }
    }
    
    func fetchData() {
        YoutubeVideo.fetchVideos { [weak self] response in
            guard let weakSelf = self else {
                return
            }
            weakSelf.videos = response
            weakSelf.tableView.reloadData()
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        cell.set(video: self.videos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil)
        let row = indexPath.row
        log?.debug("clicked row is \(row)")
        if(UserDefaults.isSet.bool(forKey: .isPaid)) {
             self.showYoutubeCell(position: row)
        } else {
            let vc = TransactionViewController()
            let bvc = BaseNavigationController(rootViewController: vc)
            self.present(bvc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastContentOffset = scrollView.contentOffset.y;
    }
    
    //MARK: -  ViewController Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.fetchData()
    }
}

extension HomeVC {
    fileprivate func showYoutubeCell(position:Int) {
        var urlString = self.datas[position]
        let url = URL.init(string: urlString)
        let vc = PlayWebViewController()
        vc.url = urlString
        vc.titleStr = "실리콘벨리"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//TableView Custom Classes
class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var channelPic: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDescription: UILabel!
    
    func customization()  {
        self.channelPic.layer.cornerRadius = 24
        self.channelPic.clipsToBounds  = true
        self.durationLabel.layer.borderWidth = 0.5
        self.durationLabel.layer.borderColor = UIColor.white.cgColor
        self.durationLabel.sizeToFit()
    }
    
    func set(video: YoutubeVideo)  {
        self.videoThumbnail.image = video.thumbnail
        self.durationLabel.text = " \(video.duration.secondsToFormattedString()) "
        self.durationLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.durationLabel.layer.borderWidth = 1.0
        self.channelPic.image = video.channel.image
        self.videoTitle.text = video.title
        self.videoDescription.text = "\(video.channel.name)  • \(video.views)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.videoThumbnail.image = UIImage.init(named: "emptyTumbnail")
        self.durationLabel.text = nil
        self.channelPic.image = nil
        self.videoTitle.text = nil
        self.videoDescription.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
    }
}
