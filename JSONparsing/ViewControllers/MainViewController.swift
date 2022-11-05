//
//  MainViewCOntrolleree.swift
//  JSONparsing
//
//  Created by Ксн Тлскн on 05.11.2022.
//

import UIKit

enum UserAction: String, CaseIterable {
    case firstAPI = "Cats Fact"
    case secondAPI = "2"
    case thirdAPI = "3"
}

enum Alert {
    case okSession
    case errorSession
    
    var title: String {
        switch self {
        case .okSession:
            return "Ok"
        case .errorSession:
            return "Error"
        }
    }
    
    var massage: String {
        switch self {
        case .okSession:
            return "You can see information in area"
        case .errorSession:
            return "Find error massage in area"
        }
    }
}

enum Link: String {
    case firstURL = "https://cat-fact.herokuapp.com"
    case secondURL = "2"
    case thirdURL = "3"
}

class MainViewController: UICollectionViewController {
    
    private let userActions = UserAction.allCases
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath)
        
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell() }
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
        
        return cell
    }
    
    // MARK: - Private Methods
    private func showAlert(with status: Alert) {
        let alert = UIAlertController(
            title: status.title,
            message: status.massage,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Thanks", style: .default)
        alert.addAction(okAction)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: - Networking
extension MainViewController {
    private func fetchCatsFact() {
        guard let url = URL(string: Link.firstURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decorder = JSONDecoder()
            do {
                let catsFact = try decorder.decode(CatsFact.self, from: data)
                print(catsFact)
                self?.showAlert(with: .okSession)
            } catch let error {
                self?.showAlert(with: .errorSession)
                print(error.localizedDescription)
            }
        }.resume()
    }
}
