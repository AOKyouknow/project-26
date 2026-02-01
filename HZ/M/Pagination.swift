//
//  Pagination.swift
//  HZ
//
//  Created by Алик on 09.01.2026.
//

import Foundation
// Здесь создаю модель для поддержки пагинации. Альтернативные варианты: бесконечные скролл на основе курсора (cursor based). Загрузка по требованию. Виртуализация. Сегментирование и ленивая загрузка. Обновление в реальном времени. ПОПРОБОВАТЬ: предзагрузку и умный кэш.
struct Pagination {
    var page: Int
    var perPage: Int // определяю размер "порции"
    var hasMore: Bool // пробую для выстраивания логики пагинации. следует ли пытаться загрузить следующую страницу данных. Есть ли еще данные для загрузки при пагинации
    
    init(page: Int = 1, perPage: Int = 10) {
        self.page = page
        self.perPage = perPage
        self.hasMore = true
    }
    
    mutating func nextPage() {
        page += 1
    }
    
    mutating func reset() {
        page = 1
        hasMore = true
    }
}
