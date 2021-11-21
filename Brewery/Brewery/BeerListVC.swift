//
//  BeerListVC.swift
//  Brewery
//
//  Created by 김태훈 on 2021/11/21.
//

import UIKit

class BeerListVC: UITableViewController {
    var beerList = [Beer]()
    var dataTasks = [URLSessionDataTask]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationBar
        title = "Brewery"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // UITableView
        tableView.prefetchDataSource = self
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        fetchBeer(of: currentPage)
        print(beerList)
    }
}

// UITableView DataSource, Delegate
extension BeerListVC: UITableViewDataSourcePrefetching {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugPrint("Rows: \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else {
            return UITableViewCell()
        }
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailVC = BeerDetailVC()
        
        detailVC.beer = selectedBeer
        self.show(detailVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            if ($0.row+1)/25+1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
}



// Data Fetching
private extension BeerListVC {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
            dataTasks.firstIndex(where: { task in
                task.originalRequest?.url == url }) == nil
            else { return }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: req) {[weak self] data, response, err in
            guard err == nil,
                    let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                      print("Error: URLSession data Task \(err?.localizedDescription ?? "")")
                      return
                  }
            
            switch response.statusCode {
            case (200...299): // 성공
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499): // 클라이언트 에러
                print("""
                      Error: Client error \(response.statusCode)
                        Response: \(response)
                """)
                
            case (500...599): // 서버 에러
                print("""
                      Error: Server error \(response.statusCode)
                        Response: \(response)
                """)
            default:
                print("""
                      Error: \(response.statusCode)
                        Response: \(response)
                """)
            }
        }
        
        dataTask.resume()
        dataTasks.append(dataTask)
    }
}
