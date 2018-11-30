//
//  WJMySelfRecordCell.swift
//  SwiftDemo1
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import SDWebImage

class WJMySelfRecordCell: UITableViewCell {
    var iconImage:UIImageView!
    var labletitle:UILabel!
    var labletime:UILabel!
    let videoPicture:String = "?x-oss-process=video/snapshot,t_1000,f_jpg,w_400,h_400,m_fast"
    let placeholderBlackImage:String = "not_pic"

//    private var tempModel:NSDictionary? = NSDictionary()
//    var model : NSDictionary {
//        set {
//            tempModel = newValue
//            self.labletitle?.text = tempModel?["intro"] as? String
//            self.labletime?.text = tempModel?["create_time"] as? String
//            var url = "http://win2.qbt8.com/qhzjsc/Public/uploads/shop/Content/20180905/5b8f7b4e193d6.jpg"
//              iconImage.sd_setImage(with: URL.init(string: (url)), placeholderImage: UIImage.init(named: placeholderBlackImage), options: SDWebImageOptions(rawValue: 0), completed: nil)
//            //在这里给cell里的属性赋值
//        }
//        get {
//            return (self.tempModel)!
//        }
//
//    }
    var model:Record = Record(){
        didSet{
            
            var url:String = model.picture
            if model.video_url.count > 0 {
                url = model.video_url + videoPicture
            }
            iconImage.sd_setImage(with: URL.init(string: (url)), placeholderImage: UIImage.init(named: placeholderBlackImage), options: SDWebImageOptions(rawValue: 0), completed: nil)
            labletitle.text = model.intro
            labletime.text = model.create_time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpView() {
        
        iconImage = UIImageView().then({
            $0.image = UIImage.init(named: "玩具列表-3")
//            $0.setContentImageView()
            contentView.addSubview($0)
            _ = $0.sd_layout().centerYEqualToView(contentView)?.leftSpaceToView(contentView,16)?.heightRatioToView(contentView,0.8)?.autoWidthRatio(1.3)
        })
        
        labletitle = UILabel().then({
            $0.textColor = UIColor.black
            $0.text = "宝宝瘦不等于营养不良，宝宝瘦不等于营养不良，宝宝瘦不等于营养不良,宝宝瘦不等于营养不良，"
            $0.textAlignment = .left
            $0.numberOfLines = 2
            $0.font = UIFont.systemFont(ofSize: 16)
            contentView.addSubview($0)
            _ = $0.sd_layout().leftSpaceToView(iconImage,10)?.rightSpaceToView(contentView,16)?.topEqualToView(iconImage)?.heightIs(40)
            
        })
        
        labletime = UILabel().then({
            $0.textColor = UIColor.darkGray
            $0.text = "2017-7-25"
            $0.textAlignment = .left
            $0.numberOfLines = 2
            $0.font = UIFont.systemFont(ofSize: 14)
            contentView.addSubview($0)
            _ = $0.sd_layout().leftSpaceToView(iconImage,10)?.rightSpaceToView(contentView,16)?.bottomEqualToView(iconImage)?.heightIs(20)
            
        })
    }
}
