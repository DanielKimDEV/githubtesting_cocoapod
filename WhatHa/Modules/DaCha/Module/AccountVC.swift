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

class AccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties


    @IBOutlet weak var tableView: UITableView!
//    let menuTitles = ["ConnectBitBerry", "SubscribeBitTube", "DisconnectBitBerry"]
    let menuTitles = ["비트베리 연결 끊기 / 환불 하기", "전화번호 변경하기", "전화번호 리셋"]
    var items = 0
    var user = User.init(name: "Loading", profilePic: UIImage(), backgroundImage: UIImage(), playlists: [Playlist]())
    var lastContentOffset: CGFloat = 0.0
    
    
    //MARK: -  ViewController Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UserDefaults.isSet.bool(forKey: .isConnected)) {
            self.checkWallet()
        }
   
    }
    //MARK: Methods

    func customization() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
        self.tableView.bounces = false
        
        User.fetchData { [weak self] response in
            guard let weakSelf = self else {
                return
            }
            weakSelf.user = response
            weakSelf.items += response.playlists.count
            weakSelf.tableView.reloadData()
        }
        self.view.backgroundColor = WhiteColor
        navigationController?.navigationBar.backgroundColor = NaviColor
        
        self.navigationController?.navigationBar.tintColor = WhiteColor
    
        navigationItem.titleLabel.textColor = WhiteColor
        navigationItem.titleLabel.text = "계정"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch(row) {
        case 1:
            self.presentCheckBitberryConnect()
            break;
        case 2:
            self.presentChangePhoneNumber()
            break;
        case 3:
            self.resetPhoneNumber()
            break;
        default:
            break;
        }
    }
    
    // MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! AccountHeaderCell
            cell.backgroundImage.backgroundColor = UIColor(hexString: "#363636")
            var amount = ""
            var titleText = UserDefaults.isSet.bool(forKey: .isConnected) ? "Connect" : "DisConnect"
            
            if(UserDefaults.isSet.bool(forKey: .isConnected)) {
               amount = "잔고 : " + UserDefaults.UserData.string(forKey: .Amount) + " SPT"
            }
            
            cell.bitberryTitle.text = "BitBerry Status : \(titleText)"
            cell.bitberryAmount.text = " \(amount)"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as! AccountMenuCell
            cell.menuTitles.text = self.menuTitles[indexPath.row - 1]
            cell.menuIcon.image = UIImage.init(named: self.menuTitles[indexPath.row - 1])
           return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as! AccountMenuCell
            cell.menuTitles.text = self.menuTitles[indexPath.row - 1]
            cell.menuIcon.image = UIImage.init(named: self.menuTitles[indexPath.row - 1])
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as! AccountMenuCell
            cell.menuTitles.text = self.menuTitles[indexPath.row - 1]
            cell.menuIcon.image = UIImage.init(named: self.menuTitles[indexPath.row - 1])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as! AccountMenuCell
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        }
    }
}

extension AccountVC {
    fileprivate func presentConnectBitBerry() {
        let vc = ConnectViewController()
        let bvc = BaseNavigationController(rootViewController : vc)
        bvc.navigationController?.navigationBar.backgroundColor = WhiteColor
        self.present(bvc, animated: true)
    }
    
    fileprivate func presentSubscribeItem() {
        let vc = TransactionViewController()
        let bvc = BaseNavigationController(rootViewController : vc)
        self.present(bvc, animated: true)
    }
    
    fileprivate func presentCheckBitberryConnect() {
        let vc = DisConnectAccountViewController()
        let bvc = BaseNavigationController(rootViewController : vc)
        self.present(bvc, animated: true)
    }
    
    fileprivate func presentChangePhoneNumber() {
        let vc = LoginViewController()
        let bvc = BaseNavigationController(rootViewController : vc)
        self.present(bvc, animated: true)
    }
    
    fileprivate func resetPhoneNumber() {
        UserDefaults.UserData.set("", forKey: .PhoneNumber)
        SwiftToast.showSwiftToast(message: "전화번호가 리셋 되었습니다. 앱을 종료후 다시 시작해주세요.", duration: 1.0, vc: self)
    }
}

class AccountHeaderCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bitberryTitle: UILabel!
    @IBOutlet weak var bitberryAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class AccountMenuCell: UITableViewCell {
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuTitles: UILabel!
    
}

class AccountPlaylistCell: UITableViewCell {
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var numberOfVideos: UILabel!
    
    override func awakeFromNib() {
        self.pic.layer.cornerRadius = 5
        self.pic.clipsToBounds = true
    }
}

extension AccountVC {
    fileprivate func checkWallet() {
        NetworkManager.requestWallets() {
            (successCode, data, isSuccess, errString) in
            if(isSuccess && data?.items! != nil && (data?.items!.count)! > 0) {
                for(_, value) in (data?.items?.enumerated())! {
                    log?.debug("wallet id is \(value.id)")
                    if(value.currencyCode == "SPT2") {
                        log?.debug("wallet id is SPT22222222!!!")
                        if let walletID = value.id {
                            UserDefaults.UserData.set(walletID, forKey: .SPTWalletID)
                        }
                        
                        if let address = value.address {
                            UserDefaults.UserData.set(address, forKey: .SPTAddress)
                        }
                        
                        if let amount = value.balance {
                            UserDefaults.UserData.set(amount, forKey: .Amount)
                        }
                        self.tableView.reloadData()
                    }
                }
            } else {
                SwiftToast.showSwiftToast(message: "Error", duration: 0.5, vc: self)
            }
        }
    }
}
