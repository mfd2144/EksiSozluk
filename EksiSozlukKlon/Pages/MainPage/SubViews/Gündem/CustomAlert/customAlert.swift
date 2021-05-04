//Custom Alert UIView Class in swift 4. And Usage ##

import UIKit




class CustomAlert:UIViewController{
    var topics:[String]?
    var settingsArray:[Bool]?
    var delegate:CustomAlertDelegate?
    
    var settings:[String : Bool]?{
        didSet{
            var string = [String]()
            var bool = [Bool]()
            for (keys,values) in settings!.sorted(by: {$0.key < $1.key}){
                string.append(keys)
                bool.append(values)
            }
            topics = string
            settingsArray = bool
        }
    }
    
    let mainView:UIView={
        let view = UIView()
        view.layer.cornerRadius = 30
        view.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY-380)
        view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 420)
        view.backgroundColor = .systemGray6
        return view
    }()
    
    lazy var TopStack:UIStackView={
        let image = UIImageView()
        image.image =  UIImage(systemName: "slider.vertical.3")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addConstraint(.init(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        image.addConstraint(.init(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))

        image.layer.cornerRadius = 20
        image.backgroundColor = .systemGray3
        image.tintColor = .darkGray
        image.contentMode = .center
        
        let label = UILabel()
        label.text = "filtrele"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        let stack1 = UIStackView(arrangedSubviews: [image,label])
        stack1.axis = .horizontal
        stack1.spacing = 10
        stack1.distribution = .fill
        
        
        
        
        let label2 = UILabel()
        label2.text = "set agenda segment to see which entry category you want to see"
        label2.numberOfLines = 0
        label2.textAlignment = .center
        let stack2 = UIStackView(arrangedSubviews: [stack1,label2])
        stack2.axis = .vertical
        stack2.distribution = .fillEqually
        stack2.spacing = 10
        stack2.alignment = .center
        stack2.backgroundColor = .systemGray6
        stack2.frame.origin = CGPoint(x:0, y: 30)
       
        stack2.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 100)
      return stack2
    }()
    
    
    let tableView:UITableView = {
        let view = UITableView()
        view.frame.origin = CGPoint(x: 0, y: 130 )
        view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 200)
        view.allowsSelection = false
        view.isScrollEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        setSubViews()
        settings = AgendaSettings.fetchStartingSettings()
        
        tableView.register(CustomaAlertCell.self, forCellReuseIdentifier: "AlertCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let swipe = UIPanGestureRecognizer(target: self , action: #selector(viewSpiweDown(_ :)))
        mainView.addGestureRecognizer(swipe)
        swipe.delegate = self as? UIGestureRecognizerDelegate
    }
    
    
    private func setSubViews(){

        mainView.addSubview(TopStack)
        mainView.addSubview(tableView)
        view.addSubview(mainView)
    }
    @objc private func viewSpiweDown(_ gesture:UIPanGestureRecognizer){
    
        if let swipeView = gesture.view {
            if gesture.state == .began || gesture.state == .changed{
                let translation = gesture.translation(in: self.view)
                if swipeView.frame.origin.y >= UIScreen.main.bounds.maxY-380 {
                    swipeView.frame.origin.y += translation.y
                }
                gesture.setTranslation(CGPoint.zero, in: view.self)
            }else if gesture.state == .ended{
                if swipeView.frame.origin.y >= UIScreen.main.bounds.maxY-280 {
                    UIView.animate(withDuration: 0.2) { [self] in
                        swipeView.frame.origin.y = UIScreen.main.bounds.maxY
                        dismiss(animated: true, completion: nil)
                    }
                }
                
                
                UIView.animate(withDuration: 0.2) {
                    swipeView.frame.origin.y = UIScreen.main.bounds.maxY-380
                }
            
            }
           
        }
       
    }
    
}

extension CustomAlert:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath) as? CustomaAlertCell, let topics = topics  else { return UITableViewCell()}
        cell.setCell(topics[indexPath.row],settingsArray![indexPath.row], self)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 50
    }
    
    
}

extension CustomAlert:AlertCellDelegate{
    func senderChanged(_ sender: UISwitch,_ text:String) {
        settings![text] = sender.isOn
        guard let settings = settings else {return}
        AgendaSettings.saveData(settings)
        delegate?.settingsDidChanged()
        
    }
    
    
}

protocol CustomAlertDelegate{
    func settingsDidChanged()
}




   
