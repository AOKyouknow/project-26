//
//  One.swift
//  HZ
//
//  Created by Алик on 01.10.2025.
//

/*
 На первой вкладке — коллекция случайных фотографий с Unsplash. Вверху строка поиска по фотографиям с Unsplash. При нажатии на ячейку пользователь попадает на экран подробной информации.
 */

import UIKit

class One: UIViewController {
    
    
    // MARK: - Variables
    //https://www.youtube.com/watch?v=5Qj4dyEnJ2s делаю как мужик, который рассказывает как работать с collection view
    // 1) первое. создаю массив изображений.
    private var images: [UIImage] = []
    private let unsplashService: UnsplashServiceProtocol = UnsplashService()//после сервиса //TODO: 3 - иницализация классов должно происходить в ините, извне, на тот случай, если ты захочешь исползовать другой сервис, но под этим же протоколом
    private let loadingIndicator = UIActivityIndicatorView(style: .large)//после сервиса
    
    //MARK: - Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.accessibilityScroll(.down) //TODO: 1 - зачем это нужно?
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)// почему здесь self после обращения?это обращение к типу (метатип), а не к экземпляру. Нужно для регистрации класса - говорит мне чат и всё равно нихуя не ясно.
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // к чему мы приравниваем. //TODO: UI получил странные отступы, лучше привязываться к SafeAreaInsets
        //TODO: 1 - любые числа в коде считаются "магическими", aka magic numbers, их надо выносить в константы
        collectionView.alwaysBounceVertical = true // тоже хз зачем. а изображение прыгает на краях. //TODO: не нужно
        
        collectionView.contentInsetAdjustmentBehavior = .never// а это что? //TODO: - 1 - тоже не знаю, что это. Надо разбираться, код, который ты не понимаешься, лучше просто так не оставлять и изучить
        
        return collectionView
        
    }() //здесь исправил. добавил lazy. добавил равно после объявления переменной и скобки после тела ленивого вычисления.
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemRed //TODO: 1 - можно без self, и где systemRed?
        // Do any additional setup after loading the view.
        
        //ЗДЕСЬ ДОЛЖЕН БЫТЬ ЦИКЛ, ПЕРЕБИРАЮЩИЙ ИЗОБРАЖЕНИЯ!!!!!!!!!!!!!
        for _ in 0...25 { //TODO: 1 - вынести в отдельный метод. Я увидел только эти картинки, у тебя фактическая загрузка работает? может быть у меня прболема с доступами, я поэтому уточняю
            if let image = UIImage(systemName: "photo") {  // 2. Пробуем создать изображение
                images.append(image) // 3. Добавляем в массив
            }
        }
        setupLoadingIndicator()
        loadRandomPhotos()
        
        setupUI()
        
            //ПЕРЕМЕСТИЛ ВНУТРЬ viewDidLoad
        //это прописываю после регистрации cell. сделал модель, зарегистрировал, теперь сюжа прописываю.
        self.collectionView.dataSource = self //TODO: - чтобы показывать ячейки
        self.collectionView.delegate = self
        //как только прописал эти вещи, потребовалось создать протокол под классом.нахуя?:D //TODO: для того, чтобы можно было работать с ячейками в целом, обрабатывать тачи и прочее
    }
    
    private func setupLoadingIndicator() { //TODO: мы его так и не увидели, он точно есть? видим красные плейсхолдеры, не индикаторы
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .systemGray
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    private func loadRandomPhotos() {
            loadingIndicator.startAnimating()
            
            unsplashService.fetchRandomPhotos(count: 26) { [weak self] result in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    
                    switch result {
                    case .success(let downloadedImages):
                        self?.images = downloadedImages
                        self?.collectionView.reloadData()
                        
                    case .failure(let error):
                        print("Error loading photos: \(error)")
                       
                    }
                }
            }
        }
    
    
    
    private func setupUI() {
        self.view.backgroundColor = .systemGray //TODO: 1 - второй раз сетапишь бэкграунд и что-то я его снова не вижу
        
        
        // установил constrains
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false // это что такое? //TODO: это необходимо т.к. до констрейнтов использовались так называемые маски, и как только появились констрейнты, айос создали переход с масок на констрейнты с помощью данной переменной, автоматический переход. Когда мы делаем false мы говорим - автоматически не переходим с масок на констрейнты, мы задаем их сами (ниже).
        
        NSLayoutConstraint.activate([ //TODO: многоо лишних self
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            //а это что? //TODO:  почитай сам, в двух словах не опишу - это констрейнты, ограничения для верного расположения UI,
            /*видимо это команды UIKit для границ. обязательные?*/ //TODO: - да 
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        
        
    }
    
}
    
    
    
    
    
    
    
    
    
    
  // MARK: - ПРОТОКОЛЫ
    


//после написания методов автоматически добавились две функции collectionView.как, блять, это работает. понятно только нихуя :)
extension One: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell//зачем здесь это приведение?
        else {
            fatalError("Failed to dequeue CustomCollectionViewCell in OneController")
        }
        
        let image = self.images[indexPath.row] // это какая-то банальная херня, которая была в уроках, но я так и не допёр что это. Количество строк и что-то такое.
        cell.configure(with: image) // и это нахуй добавлять?откуда я должен знать сколько ещё всякой ебанины писать.
        return cell
    }
    
    
    
    
}

    //этот протокол создаём вторым. как я понял, для настройки размера изображений в Colliction View
extension One: UICollectionViewDelegateFlowLayout{
    //набираем sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalInsets: CGFloat = 40
        let totalSpacingBetweenCells: CGFloat = 4
        let availableWidth = collectionView.frame.width - totalHorizontalInsets - totalSpacingBetweenCells
        let cellWidth = availableWidth / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    //набираем minimumLineSpacing Вертикальный
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //ещё здесь хер знает для чего добавил insetForSectionAt
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets (top: 20, left: 20, bottom: 20, right: 20)
    } // вот такие настройки не работают хз почему. остаётся пространство сверху экрана, даже если выставить 0 для top and bottom
    
    
    
    

