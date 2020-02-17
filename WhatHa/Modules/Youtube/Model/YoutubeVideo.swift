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

import Foundation
import UIKit

class YoutubeVideo {
    
    //MARK: Properties
    let thumbnail: UIImage
    let title: String
    let views: Int
    let channel: Channel
    let duration: Int
    var YoutubeVideoLink: URL!
    let likes: Int
    let disLikes: Int
    var suggestedYoutubeVideos = [SuggestedYoutubeVideo]()
    
    //MARK: Inits
    init(title: String, channelName: String) {
        self.thumbnail = UIImage.init(named: "vincent")!
        self.title = title
        self.views = Int(arc4random_uniform(1000000))
        self.duration = Int(arc4random_uniform(400))
        self.likes = Int(arc4random_uniform(1000))
        self.disLikes = Int(arc4random_uniform(1000))
        self.channel = Channel.init(name: channelName, image: UIImage.init(named: "channel0")!)
    }
    

    //MARK: Methods
    class func fetchVideos(completion: @escaping (([YoutubeVideo]) -> Void)) {
        let YoutubeVideo1 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 1", channelName: "DanielTube")
        let YoutubeVideo2 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 2", channelName: "DanielTube")
        let YoutubeVideo3 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 3", channelName: "DanielTube")
        let YoutubeVideo4 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 4", channelName: "DanielTube")
        let YoutubeVideo5 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 5", channelName: "DanielTube")
        let YoutubeVideo6 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 6", channelName: "DanielTube")
        let YoutubeVideo7 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 7", channelName: "DanielTube")
        let YoutubeVideo8 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 8", channelName: "DanielTube")
        let YoutubeVideo9 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 9", channelName: "DanielTube")
        let YoutubeVideo10 = YoutubeVideo.init(title: "실리콘벨리 Season4 - 10", channelName: "DanielTube")

//        let YoutubeVideo7 = YoutubeVideo.init(title: "TensorFlow Basics - Deep Learning with Neural Networks p. 2", channelName: "sentdex")
//        let YoutubeVideo8 = YoutubeVideo.init(title: "Scott Galloway: The Retailer Growing Faster Than Amazon", channelName: "L2inc")
        var items = [YoutubeVideo1, YoutubeVideo2, YoutubeVideo3, YoutubeVideo4, YoutubeVideo5, YoutubeVideo6, YoutubeVideo7, YoutubeVideo8, YoutubeVideo9, YoutubeVideo10]
        completion(items)
    }
    
    class func fetchVideo(completion: @escaping ((YoutubeVideo) -> Void)) {
        let youtubeVideo = YoutubeVideo.init(title: "Big Buck Bunny", channelName: "Blender Foundation")
        youtubeVideo.YoutubeVideoLink = URL.init(string: "https://drive.google.com/file/d/1MkhjK7VoZleg27t1R_EDMIWohNdhzr3r")!
        let suggestedYoutubeVideo1 = SuggestedYoutubeVideo.init(title: "What Does Jared Kushner Believe", channelName: "Nerdwriter1")
        let suggestedYoutubeVideo2 = SuggestedYoutubeVideo.init(title: "Moore's Law Is Ending. So, What's Next", channelName: "Seeker")
        let suggestedYoutubeVideo3 = SuggestedYoutubeVideo.init(title: "What Bill Gates is afraid of", channelName: "Vox")
        let suggestedYoutubeVideo4 = SuggestedYoutubeVideo.init(title: "Why Can't America Have a Grown-Up Healthcare Conversation", channelName: "vlogbrothers")
        let suggestedYoutubeVideo5 = SuggestedYoutubeVideo.init(title: "TensorFlow Basics - Deep Learning with Neural Networks p. 2", channelName: "sentdex")
        let items = [suggestedYoutubeVideo1, suggestedYoutubeVideo2, suggestedYoutubeVideo3, suggestedYoutubeVideo4, suggestedYoutubeVideo5]
        youtubeVideo.suggestedYoutubeVideos = items
        completion(youtubeVideo)
    }
}

struct SuggestedYoutubeVideo {
    
    let title: String
    let channelName: String
    let thumbnail: UIImage
    
    init(title: String, channelName:String) {
        self.title = title
        self.channelName = channelName
        self.thumbnail = UIImage.init(named: title)!
    }
}

class Channel {
    
    let name: String
    let image: UIImage
    var subscribers = 0
    
    class func fetchData(completion: @escaping (([Channel]) -> Void)) {
        var items = [Channel]()
        for i in 0...18 {
            let name = ""
            let image = UIImage.init(named: "channel\(i)")
            let channel = Channel.init(name: name, image: image!)
            items.append(channel)
        }
        completion(items)
    }

    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}
