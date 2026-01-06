//
//  CustomCollectionViewCell.swift
//  HZ
//
//  Created by Алик on 05.10.2025.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    private let myImageView: UIImageView = {
        
        let iv = UIImageView() //TODO: 1 - давай полные названия переменным, без сокращений, чтобы можно было исходя из названия понять, что это - imageView
        iv.contentMode = .scaleAspectFill// это что? какое-то заполнение //TODO: - тип растягивания или образания изображения по вьюшке. Посмотри какие там еще есть варианты, это важно.
        iv.image = UIImage(systemName: "questionmark") //TODO: 1 - ты же вроде в One() делал плейсхолдер под картинку, не видел картинку questionmark в проекте, она точно нужна?
        iv.tintColor = .white
        iv.clipsToBounds = true
        return iv
        
        
    }()
    
    public func configure(with image:UIImage){
        self.myImageView.image = image
        self.setupUI()
        
    }
    
    private func setupUI(){
        self.backgroundColor = .systemRed
        
        // constrains скопированы из первого вьюконтроллера. в скобках addSubView замена с collectionView на myImageView, а это в свою очередь класс UIImageView
        self.addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false // это что такое?
                NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.topAnchor),
            //а это что?
            /*видимо это команды UIKit для границ. обязательные?*/
            myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ])
    }
    
    //похоже какой-то обязательный метод для CollectionView
    override func prepareForReuse() {
        self.myImageView.image = nil // это для чего? обновляет изображения при скроллинге? //TODO: для переиспользования ячеек, чтобы правильно устанавливались следующие изображения в ячейках. Если этого не делать, они будут мелькать.
            //после того, как сделал это, пошёл во вьюконтроллер и зарегистрировал это дело в переменной collectionView
    }
    
}
