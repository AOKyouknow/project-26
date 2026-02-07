//
//  UnplashManager.swift
//  PictureProject
//
//  Created by Алик on 07.02.2026.
//
//ВТОРОЙ ВАРИАНТ. УЛУЧШАЮ.
import Foundation
//final значит, что от него нельзя наследоваться. Закрываем для наследования. Методы внутри класса из-за диспетчеризации работают быстрее.
final class UnplashManager{
    
    //MARK: - Properties
    //делаем СИНГЛТОН - взаимодействие с классом через свойство! Через свойство получаем единственный истинный доступ
    static let shared = UnplashManager()
    let urlPictures = "https://api.unsplash.com/"
    //для полноценного синглтона создать ПРИВАТНЫЙ ИНИЦИАЛИЗАТОР!
    //MARK: - Initializer
    private init() {}
    
    //MARK: - Methods
    //первый способ completion.escaping.dispath. ЗДЕСЬ ВТОРОЙ!!!!
    func getPictures() async throws -> Images {
        
        guard let url = URL(string: urlPictures)
        
        
        
        
        
        
    }
    

}//закрытие класса
