//
//  CustomCollectionViewCell.swift
//  HZ
//
//  Created by Алик on 05.10.2025.
//

import UIKit

protocol CustomCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: CustomCollectionViewCell)
}

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    // MARK: - Delegate НОВЫЙ
        weak var delegate: CustomCollectionViewCellDelegate?
    
    
    // MARK: - UI Components
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill// aspectFit/scaleToFill(искажает)
        //imageView.image = UIImage(systemName: "questionmark") //TODO: 1 - ты же вроде в One() делал плейсхолдер под картинку, не видел картинку questionmark в проекте, она точно нужна?
        imageView.tintColor = .white
        imageView.clipsToBounds = true// без этого изображение будет выходить за края
        return imageView
     }()
    
    private let authorLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.textColor = .white
            label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            label.layer.cornerRadius = 4
            label.clipsToBounds = true
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // ✅ КНОПКА ИЗБРАННОГО
        //private 
    lazy var favoriteButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            button.tintColor = .white
            button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            button.layer.cornerRadius = 15
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Properties
        private var photoID: String?
        private let favoritesService = FavoritesService.shared
        
        // MARK: - Init
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    
    
    
    
    //MARK: - СТАРОЕ
    // публичный метод API нашей ячейки. Его вызывает внешний код.
    public func configure(with image:UIImage){
        self.myImageView.image = image
        self.setupUI() // вызывает внутренний приватный метод для расстановки constraints (ограничений/авторазметки). Важный момент: setupUI() вызывается каждый раз при настройке ячейки. Это может быть не оптимально. Обычно констрейнты выставляются один раз (например, в инициализаторе), а в configure только обновляются данные.
    }
    
    private func setupUI(){
        self.backgroundColor = .systemRed //чтобы видеть границы ячейки/ ВРЕМЕННО!
        
        //НОВОЕ
        contentView.addSubview(authorLabel)
        contentView.addSubview(favoriteButton)
        
        
        // constrains скопированы из первого вьюконтроллера. в скобках addSubView замена с collectionView на myImageView, а это в свою очередь класс UIImageView
        self.addSubview(myImageView)//добавляет imageView в иерархию представлений (view hierarchy) ячейки. Без этого imageView просто не будет отображаться.
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        //ФУНДАМЕНТАЛЬНО ВАЖНАЯ СТРОКА ДЛЯ AUTOLAYOUT. У UIView есть старая система авторазметки на основе фреймов (frame) и флагов (autoresizingMask). Для работы с современной системой ограничений (Constraints, AutoLayout) необходимо отключить эту старую систему, установив данное свойство в false. Если этого не сделать, система попытается преобразовать constraints во флаги autoresizingMask, что почти всегда приводит к конфликтам и непредсказуемому поведению или крашу.
                NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.topAnchor),
            myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                        authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                        authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: favoriteButton.leadingAnchor, constant: -8),
                        authorLabel.heightAnchor.constraint(equalToConstant: 24),
                        
                        favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                        favoriteButton.widthAnchor.constraint(equalToConstant: 30),
                        favoriteButton.heightAnchor.constraint(equalToConstant: 30)
                ]) // Результат: imageView растянется на всю доступную площадь ячейки, заполнит её от края до края. Это именно то, что нужно для режима .scaleAspectFill.а если это не указать??? scaleAspectFill разве не должен без этих указаний автоматически это сделать?
    }
    
    //обязательный метод для CollectionView. Это переопределенный (override) метод родительского класса UICollectionViewCell.
    override func prepareForReuse() {
        self.myImageView.image = nil // для переиспользования ячеек, чтобы правильно устанавливались следующие изображения в ячейках. Если этого не делать, они будут мелькать. после того, как сделал это, пошёл во вьюконтроллер и зарегистрировал это дело в переменной collectionView. Этот метод вызывается системой перед тем, как ячейка будет повторно использована (reused) для отображения нового элемента данных. Коллекция не создает новую ячейку для каждого элемента (это убило бы производительность), а берет уже невидимую (ушедшую за экран) и готовит её для нового контента. Это паттерн для борьбы с "мельканием" (flashing) старых изображений.Проблема: Представьте, что ячейка 1 показывает большое изображение, которое загружается медленно. Пользователь быстро проскроллил, и эта ячейка ушла с экрана. Система берет эту же самую ячейку (ячейку 1), чтобы показать в ней данные для ячейки 10, но новое изображение для ячейки 10 еще не загружено. На мгновение пользователь увидит в ячейке 10 старое изображение от ячейки 1, пока не загрузится новое. Это и есть "мелькание". Решение: В prepareForReuse() мы сбрасываем содержимое (в данном случае обнуляем изображение). Теперь, пока загружается новая картинка, ячейка будет пустой (или с плейсхолдером, если он задан в setupUI). Это делает интерфейс предсказуемым. это опциональный метод жизненного цикла ячейки, который настоятельно рекомендуется переопределять для сброса состояния при переиспользовании.
        //новое
        super.prepareForReuse()
        authorLabel.text = nil
        photoID = nil
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        
        
    }
    
    
    //НОВОЕ
    // MARK: - Configure
        func configure(with image: UIImage, author: String = "Unknown", photoId: String? = nil) {
            myImageView.image = image
            authorLabel.text = author
            self.photoID = photoId
            
            // Проверяем, в избранном ли это фото
            if let id = photoId {
                let isFavorite = favoritesService.isFavorite(id: id)
                updateFavoriteButton(isFavorite: isFavorite)
            }
        }
        
        //private 
    func updateFavoriteButton(isFavorite: Bool) {
            let imageName = isFavorite ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
            favoriteButton.tintColor = isFavorite ? .systemRed : .white
        }
        
        // MARK: - Actions
        @objc private func favoriteButtonTapped() {
            delegate?.didTapFavoriteButton(in: self)
        }
        
        
}//конец класса
    
    

