//
//  ViewController.swift
//  MemeApp
//
//  Created by Виталик Молоков on 23.02.2024.
//

import UIKit

class MemViewController: UIViewController {
    
    //MARK: -  UI Elements
    
    private lazy var questionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите ваш вопрос"
        return textField
    }()
    
    private lazy var getMemeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Получить предсказание", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(getMemeButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 9
        return button
    }()
    
    private lazy var memeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("👍", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        button.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("👎", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        button.addTarget(self, action: #selector(rejectButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    //MARK: - Setups
    
    private func setupHierarchy() {
        view.backgroundColor = .white
        view.addSubview(questionTextField)
        view.addSubview(getMemeButton)
        view.addSubview(memeImageView)
        view.addSubview(acceptButton)      
        view.addSubview(rejectButton)
    }
    
    private func setupLayout() {
        questionTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        getMemeButton.snp.makeConstraints { make in
            make.top.equalTo(questionTextField.snp.bottom).offset(20)
            make.left.right.equalTo(questionTextField)
            make.height.equalTo(50)
        }
        
        memeImageView.snp.makeConstraints { make in
            make.top.equalTo(getMemeButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(300)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(memeImageView.snp.bottom).offset(20)
            make.width.height.equalTo(100)
        }
        
        rejectButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(memeImageView.snp.bottom).offset(20)
            make.width.height.equalTo(100)
        }
    }
    
    // Метод для отображения мема в UI
    private func loadToDisplayMemeImage(from url: URL) {
        MemeService.shared.loadMemeImage(from: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.memeImageView.alpha = 0
                    self?.memeImageView.image = image
                    UIView.animate(withDuration: 2.0) {
                        self?.memeImageView.alpha = 1
                    }
                case .failure(let error):
                    self?.showAlert(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc func getMemeButtonTapped() {
        guard let questionText = questionTextField.text, !questionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(withMessage: "Введите Ваш вопрос")
            return
        }
        rejectButton.isEnabled = true
        MemeService.shared.fetchMeme { [weak self] result in
            switch result {
            case .success(let url):
                self?.loadToDisplayMemeImage(from: url)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func acceptButtonTapped() {
        questionTextField.text = ""
        memeImageView.image = nil
        questionTextField.becomeFirstResponder()
        rejectButton.isEnabled = false
    }
    
    @objc func rejectButtonTapped() {
        getMemeButtonTapped()
    }
}
