//
//  SchoolListCell.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import UIKit

class SchoolListCell: UITableViewCell {
    let schoolImageView = UIImageView()
    let nameTextLabel = UILabel()
    var mainView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(with school: School) {
        nameTextLabel.text = school.schoolName.removeUnwantedCharacters().trimmingCharacters(in: .whitespacesAndNewlines)
        // from sf symbols
        schoolImageView.image = UIImage(systemName: "graduationcap")
    }
    
    func setupCellUI() {
        contentView.addSubview(mainView)
        mainView.backgroundColor = .white
        addMainViewConstraints()
        mainView.addSubview(schoolImageView)
        schoolImageView.contentMode = .scaleAspectFill
        schoolImageView.frame.size.height = 40.0
        schoolImageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints: [NSLayoutConstraint] = [schoolImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20.0), schoolImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor), schoolImageView.heightAnchor.constraint(equalTo: schoolImageView.widthAnchor)]
        NSLayoutConstraint.activate(imageViewConstraints)
        
        nameTextLabel.textAlignment = .left
        nameTextLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        nameTextLabel.numberOfLines = 0
        nameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextLabel.lineBreakMode = .byWordWrapping
        mainView.addSubview(nameTextLabel)
        let textLabelConstraints: [NSLayoutConstraint] = [nameTextLabel.leadingAnchor.constraint(equalTo: schoolImageView.trailingAnchor, constant: 20.0), nameTextLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10.0), nameTextLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10.0), nameTextLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10.0)]
        NSLayoutConstraint.activate(textLabelConstraints)
    }
    
    private func addMainViewConstraints() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        let mainViewConstraints: [NSLayoutConstraint] = [mainView.topAnchor.constraint(equalTo: contentView.topAnchor), mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)]
        NSLayoutConstraint.activate(mainViewConstraints)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
