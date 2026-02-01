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
    
    // MARK: - вместо variables ПРОБУЮ ПАГИНАЦИЮ
    private var images: [UIImage] = []
    private var currentPage = 1          // Текущая страница, начинаем с 1
    private var isLoading = false        // Флаг загрузки, чтобы не грузить одновременно несколько страниц
    private var hasMorePhotos = true    // Есть ли еще фото для загрузки
    private let photosPerPage = 20      // Сколько фото грузить за один раз (не 26!)
    
    
    
    
    // MARK: - Variables
    
//    // 1) первое. создаю массив изображений.
//    private var images: [UIImage] = []
//    private let unsplashService: UnsplashServiceProtocol = UnsplashService()//после сервиса //TODO: 3 - иницализация классов должно происходить в ините, извне, на тот случай, если ты захочешь исползовать другой сервис, но под этим же протоколом
//    private let loadingIndicator = UIActivityIndicatorView(style: .large)//Создает индикатор загрузки (крутящийся спиннер).Показывается пользователю, когда идёт загрузка фотографий
    
    //MARK: - Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)// почему здесь self после обращения?это обращение к типу (метатип), а не к экземпляру. Нужно для регистрации класса - Нужно, чтобы система знала, какой класс использовать для создания ячеек
        collectionView.contentInsetAdjustmentBehavior = .always // Включаем автоматическую корректировку safe area
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
            // ВОТ ЗДЕСЬ ПРОПИСАНО СТРОГО 26 КАРТИНОК ЗАГРУЖАТЬ!!!!!!!!очереди!!!!!!
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
        // установил constrains
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false//это необходимо т.к. до констрейнтов использовались так называемые маски, и как только появились констрейнты, айос создали переход с масок на констрейнты с помощью данной переменной, автоматический переход. Когда мы делаем false мы говорим - автоматически не переходим с масок на констрейнты, мы задаем их сами (ниже).
        NSLayoutConstraint.activate([ //многоо self? команды UIKit для границ. обязательные? -да
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
//ДРУГОЙ ВАРИАНТ КОНСТРЕЙНТОВ. КОГДА collectionView учитывает safe area. когда этот вариант работает, то проявляется красный бэкграунд, который я выставил в настройках для теста. В ЧËМ ПРИНЦИПИАЛЬНАЯ РАЗНИЦА ПРИВЯЗКИ КОНСТРЕЙНТОВ К safe area????????????????
//        NSLayoutConstraint.activate([
//        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
//    ])
}
  // MARK: - ПРОТОКОЛЫ
//Создаём ячейки.
extension One: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell
        else {
            fatalError("Failed to dequeue CustomCollectionViewCell in OneController")
        }
        let image = self.images[indexPath.row]
        cell.configure(with: image)
        return cell
    }
}

// НАСТРОЙКА ИЗОБРАЖЕНИЙ В collection view!!!!!!!!!!!!
extension One: UICollectionViewDelegateFlowLayout{
    //набираем sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //ИСПРАВЛЯЮ ОТСТУПЫ И РАЗМЕРЫ ЯЧЕЕК!!!!!!!!
        let safeAreaInsets = collectionView.safeAreaInsets//Учитываем safe area insets
        let totalHorizontalInsets = safeAreaInsets.left + safeAreaInsets.right + 2 //отступы с боковых краёв.безопасная зона + 2 пункта.
        
        //Пространство между ячейками: (количество ячеек - 1) * spacing
        let numberOfItemsPerRow: CGFloat = Constants.itemsPerRow // количество ячеек, которое я планирую разместить
        let spacing: CGFloat = Constants.spacing // minimumInteritemSpacing - это расстрояние, которое остаётся между ячейками
    
        let totalSpacing = spacing * (numberOfItemsPerRow - 1) //Рассчитываем общую ширину всех зазоров между ячейками. Пример: Объекта 3, щелей между ними 2. Следовательно формула такая: количество объектов минус 1 (numberOfItemsPerRow - 1). Это число, отражающее количество отступов, мы умножили на минимальное расстояние между ячейками - на spacing.
        
        //Доступная ширина для ячеек
        let availableWidth = collectionView.bounds.width - totalHorizontalInsets - totalSpacing //Рассчитываю доступную ширину для ячеек. Берём общую доступную ширину(collectionView.bounds.width), вычитаем из неё два варианта отступов: отступ с боковых краёв (totalHorizontalInsets), отступ между ячейками (totalSpacing). Получаем пространство за исключением отступов - это всё доступное место для размещения ячеек.
        //Ширина одной ячейки
        let cellWidth = availableWidth / numberOfItemsPerRow // всю доступную ширину делим на количество элементов
        
        // Округляем для пиксельной точности. Один (1) пункт - это 2 или 3 пикселя (в зависимости от экрана). Если ширина 92.333... пункта, могут появиться размытые края. Нецелое число пикселей - это размытые края. Что делает .rounded(.down)? Округляет вниз, чтобы гарантировать, что суммарная ширина ячеек и отступов ≤ ширине collectionView. Если округлить вверх (92.3 → 93), может не хватить места! Округление вниз предотвращает вылезание за границы и обеспечивает четкие края.
        return CGSize(width: cellWidth.rounded(.down), height: cellWidth.rounded(.down))
        }
        
        
    //возвращает минимальное расстояние по вертикали между соседними строками (lines) элементов в одной секции.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //возвращает минимальное расстояние по горизонтали между соседними элементами (items), которые находятся в одной строке (line).
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //отступы (Inset) для всей секции. Создает "рамку" или "поля" вокруг всей секции. Особенно важны left и right отступы (10pt), которые не дают ячейкам прижиматься к боковым краям экрана, что улучшает внешний вид, особенно на устройствах с закругленными углами. ПОКА ОСТАВЛЯЮ 0.
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
}
