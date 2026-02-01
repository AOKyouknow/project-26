//
//  UnsplashService.swift
//  HZ
//
//  Created by Алик on 05.10.2025.
//


import UIKit
import Foundation

protocol UnsplashServiceProtocol {
    func fetchRandomPhotos(count: Int, completion: @escaping (Result<[UIImage], Error>) -> Void)
}

//TODO: 1 - можно написать некий базовы класс, который будет выполнять роль основного сервиса, то есть если тебе потребуется с 10 экранов делать 10 запросов, чтобы не писать каждый раз один и тот же код, создавая URL.session, а, например, а) наследоваться от основного класса б) сделать некий сервис прослойку, который будет обращаться к основному сервису, прокидывая в него только урл и другие нужные данные. В то же время протокол по-прежнему нужен, это очень хорошо.
class UnsplashService: UnsplashServiceProtocol {
    //TODO: 3 - можно ли как-то безопасно хранить данный ключ?
    private let accessKey = "sA_clGtZeYnKVP67LxrqQgz1xfVJfgeUqsB4scBim7k"
    private let baseURL = "https://api.unsplash.com"
    
    func fetchRandomPhotos(count: Int, completion: @escaping (Result<[UIImage], Error>) -> Void) {
        let urlString = "\(baseURL)/photos/random?count=\(count)" //TODO: 2 - отдельный билдер урлов, сервис ходит в сеть, он должен получать уже готовый урл, нужно разделять ответственность классов, один класс - одна задача
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))// перенёс перечисление в отдельный файл, но ничего не загорелось красным. Доступ остался.?????
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in //TODO: response нигде не используется, можно убрать и заменить на _
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                self?.downloadImages(from: photos, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func downloadImages(from photos: [UnsplashPhoto], completion: @escaping (Result<[UIImage], Error>) -> Void) {
        let group = DispatchGroup()
        var images: [UIImage] = []
        let lock = NSLock() // Для потокобезопасности
        
        for photo in photos {
            group.enter()
            guard let url = URL(string: photo.urls.small) else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                defer { group.leave() }
                
                if let data = data, let image = UIImage(data: data) {
                    lock.lock()
                    images.append(image)
                    lock.unlock()
                }
            }.resume()
        }
        
        group.notify(queue: .global(qos: .background)) {
            completion(.success(images))
        }
    }
}


