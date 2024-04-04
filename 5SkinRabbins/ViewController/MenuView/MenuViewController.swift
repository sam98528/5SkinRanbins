//
//  ViewController.swift
//  5SkinRabbins
//
//  Created by Jeong-bok Lee on 4/2/24.
//
import UIKit

class MenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var things: [Any] = []
    
    
    // 각 카테고리별 상품 배열
    var iceCreams: [IceCream] = IceCream.iceCream
    var cakes: [Cake] = Cake.cake
    var beverages: [Beverage] = Beverage.beverage
    var coffees: [Coffee] = Coffee.coffee
    
    var selectedIndex = 0
    
    @IBAction func cartButtonTouched(_ sender: Any) {
        let storyboard: UIStoryboard? = UIStoryboard(name: "PaymentStoryboard", bundle: Bundle.main)
        guard let vc = storyboard?.instantiateViewController(identifier: "PaymentViewController") as? PaymentViewController else {
            return
        }
        vc.things = self.things
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cartButton.tintColor = UIColor(red: 1.00, green: 0.49, blue: 0.59, alpha: 1.00)
        // UICollectionViewFlowLayout을 사용하여 컬렉션 뷰의 레이아웃 설정
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: Int(collectionView.frame.size.width / 2 - 20) , height: Int(collectionView.frame.size.height / 3) - 20)
        collectionView.collectionViewLayout = flowLayout
        
        let backBarButtonItem = UIBarButtonItem(title: "돌아가기", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = UIColor(red: 0.98, green: 0.42, blue: 0.51, alpha: 1.00)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        
        // 컬렉션 뷰 설정
        setupCollectionView()
        // 초기에는 세그먼트 인덱스 0으로 설정하고 아이스크림 상품을 로드
        segmentedControl.selectedSegmentIndex = selectedIndex
        loadIceCreams()
    }
    
    // 컬렉션 뷰 데이터 소스 설정
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
    // 세그먼트 값 변경 시 동작
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadIceCreams()
            titleLabel.text = "Ice Cream"
        case 1:
            loadCakes()
            titleLabel.text = "Ice Cream Cake"
        case 2:
            loadBeverages()
            titleLabel.text = "Beverage"
        case 3:
            loadCoffees()
            titleLabel.text = "Coffee"
        default:
            break
        }
    }
    
    // 컬렉션 뷰 셀 수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return iceCreams.count
        case 1:
            return cakes.count
        case 2:
            return beverages.count
        case 3:
            return coffees.count
        default:
            return 0
        }
    }
    
    // 컬렉션 뷰 셀 선택 시 동작
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // 아이스크림 상품 선택 시 상세 화면으로 이동
            print(iceCreams[indexPath.row].koreanName)
            let storyboard: UIStoryboard? = UIStoryboard(name: "DetailsView", bundle: Bundle.main)
            guard let vc = storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController else {
                return
            }
            vc.selectedMenu = iceCreams[indexPath.row]
            vc.delegate = self
            vc.modalPresentationStyle = .automatic
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true,completion: nil)
        case 1:
            // 케이크 상품 선택 시 동작
            //print(cakes[indexPath.row].koreanName)
            things.append(cakes[indexPath.row])
            updateCartBadge()
        case 2:
            // 음료 상품 선택 시 동작
            //print(beverages[indexPath.row].koreanName)
            things.append(beverages[indexPath.row])
            updateCartBadge()
        case 3:
            // 커피 상품 선택 시 동작
            //print(coffees[indexPath.row].koreanName)
            things.append(coffees[indexPath.row])
            updateCartBadge()
        default:
            print("error")
        }
    }

    // 컬렉션 뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
         // 컬렉션 뷰 셀 디자인
         cell.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
         cell.layer.cornerRadius = 8
         cell.layer.borderWidth = 1
         cell.layer.borderColor = UIColor(red: 0.932, green: 0.932, blue: 0.932, alpha: 1).cgColor
     
        // 해당 카테고리의 상품으로 셀 구성
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let iceCream = iceCreams[indexPath.item]
            cell.configure(with: iceCream)
        case 1:
            let cake = cakes[indexPath.item]
            cell.configure(with: cake)
        case 2:
            let beverage = beverages[indexPath.item]
            cell.configure(with: beverage)
        case 3:
            let coffee = coffees[indexPath.item]
            cell.configure(with: coffee)
        default:
            break
        }
        return cell
    }
    
    // 카테고리별 상품 로드 함수
    func loadIceCreams() {
        collectionView.reloadData()
    }
    
    func loadCakes() {
        collectionView.reloadData()
    }
    
    func loadBeverages() {
        collectionView.reloadData()
    }
    
    func loadCoffees() {
        collectionView.reloadData()
    }
    func updateCartBadge() {
        cartButton.addBadge(number: things.count)
    }
}

extension MenuViewController : FlavorDelegate {
    func finishedFlavorEditing(iceCream: IceCream) {
        things.append(iceCream)
        updateCartBadge()
    }
    
    
}

extension UIButton {
  func addBadge(number: Int) {
    let badgeLabel = UILabel(frame: CGRect(x: self.frame.size.width - 15, y: -5, width: 20, height: 20))
    badgeLabel.backgroundColor = .red
    badgeLabel.textColor = .white
    badgeLabel.textAlignment = .center
    badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.width / 2
    badgeLabel.layer.masksToBounds = true
    badgeLabel.text = "\(number)"
    badgeLabel.font = UIFont.systemFont(ofSize: 12)
    // Remove previous badge views
    for subview in self.subviews {
      if subview.tag == 99 {
        subview.removeFromSuperview()
      }
    }
    // Add new badge view
    badgeLabel.tag = 99
    self.addSubview(badgeLabel)
  }
}
