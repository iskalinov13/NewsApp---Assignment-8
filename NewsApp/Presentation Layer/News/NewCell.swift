//
//  NewCell.swift
//  NewsApp
//
//  Created by FIskalinov on 14.11.2024.
//

import UIKit
import SnapKit
import AlamofireImage
import Alamofire

class NewCell: UICollectionViewCell {
    
    private let newImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newImage.af.cancelImageRequest()
        newImage.image = nil
    }
    
    private func layoutUI() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .white
        
        [newImage, titleLabel, dateLabel, contentLabel].forEach {
            addSubview($0)
        }
        
        newImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(newImage.snp.bottom).offset(8)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(8)
        }
        
    }
    
    func configure(data: New) {
        guard
            let imageUrl = data.urlToImage,
            let url = URL(string: imageUrl)
        else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.newImage.image = UIImage(data: imageData)
            }
        }
        titleLabel.text = data.title ?? ""
        if let publishedDate = data.publishedAt {
            dateLabel.text = formatDate(publishedDate: publishedDate)
        }
        contentLabel.text = data.content ?? ""
    }
        
    private func formatDate(publishedDate: String) -> String {
        let dbDateFormatter = DateFormatter()
        dbDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = dbDateFormatter.date(from: publishedDate){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let todaysDate = dateFormatter.string(from: date)
            return  "Published : " + todaysDate
        }
        
        return publishedDate
    }
}
