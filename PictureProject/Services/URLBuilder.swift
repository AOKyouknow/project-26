//
//  URLBuilder.swift
//  PictureProject
//
//  Created by Алик on 11.02.2026.
//

import Foundation

enum UnsplashEndpoint {
    case searchPhotos(query: String, page: Int, perPage: Int)
    case randomPhotos(count: Int)
    case photo(id: String)
    
    //Вычисляемое свойство. Определяет путь для каждого эндпоинта после базового URL.
    var path: String {
        switch self {
        case .searchPhotos:
            return "/search/photos"
        case .randomPhotos:
            return "/photos/random"
        case .photo(let id):
            return "/photos/\(id)"
        }
    }
    
//Создает массив параметров запроса (то, что идет после ? в URL, например, ?query=nature&page=1). Используется структура URLQueryItem — стандартный способ в iOS.
//URLQueryItem используются для создания строки запроса (query string) в веб-адресе (URL).
//У вас есть настройки запроса (что искать, сколько фото). queryItems упаковывает эти настройки в такой вид, чтобы их можно было прицепить к адресу сайта (к URL).
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchPhotos(let query, let page, let perPage):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
        case .randomPhotos(let count):
            return [URLQueryItem(name: "count", value: "\(count)")]
        case .photo:
            return [] //Для запроса конкретного фото по ID не нужны дополнительные параметры в URL (ID обычно вставляется в сам путь, например /photos/abc123). Поэтому он возвращает пустой массив — добавлять нечего.
        }
    }
}

// URLBuilder — это фасад (Facade Pattern)
class URLBuilder {
    // Базовый адрес API, общий для всех запросов
    private let baseURL = "https://api.unsplash.com"
    func buildURL(for endpoint: UnsplashEndpoint) -> URL? {
        // Создаем компоненты URL из базового адреса
        var components = URLComponents(string: baseURL)
        // Добавляем путь эндпоинта
        components?.path = endpoint.path
        // Добавляем query-параметры
        components?.queryItems = endpoint.queryItems
        // Возвращаем собранный URL (может быть nil при ошибке)
        return components?.url
    }
}
