//
//  DataManager.swift
//  MemeApp
//
//  Created by Виталик Молоков on 23.02.2024.
//

import UIKit

class MemeService {
    
    //MARK: - Properties
    
    static let shared = MemeService()
    
    //MARK: - Life Cycle
    
    private init() {}
    
    private func createError(withMessage message: String) -> Error {
        return NSError(domain: "MemeService", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    //MARK: - Methods
    
    // Метод для выполнения запроса к API и получения мема
    func fetchMeme(completion: @escaping (Result<URL, Error>) -> Void) {
        let url = URL(string: "https://api.imgflip.com/get_memes")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(self.createError(withMessage: "Ошибка сервера")))
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonObject = jsonResponse as? [String: Any],
                      let data = jsonObject["data"] as? [String: Any],
                      let memes = data["memes"] as? [[String: Any]],
                      let meme = memes.randomElement(),
                      let imageUrlString = meme["url"] as? String,
                      let imageUrl = URL(string: imageUrlString) else {
                    completion(.failure(self.createError(withMessage: "Ошибка парсинга данных")))
                    return
                }
                completion(.success(imageUrl))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Метод загрузки мема по URL
    func loadMemeImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(self.createError(withMessage: "Ошибка данных изображения")))
                return
            }
            completion(.success(image))
        }
        task.resume()
    }
}



