//
//  CustomSegementedControl.swift
//  Noti
//
//  Created by Seti Vega on 12/9/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegementedControl: UIControl {
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0

    @IBInspectable
    var borderWidth: CGFloat = 0{
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear{
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var buttonBorderWidth: CGFloat = 0{
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var buttonBorderColor: UIColor = .clear{
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var commaSeparatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = .darkGray{
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorRadius: Int = 0{
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var animate: Bool = false{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var fontName: String = "HelveticaNeue"{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var fontType: String = "Medium"{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var fontSize: Int = 12 {
        didSet{
            updateView()
        }
    }
    
    
    
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            button.layer.cornerRadius = frame.height/2
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.layer.borderWidth = buttonBorderWidth
            button.layer.borderColor = buttonBorderColor.cgColor
            button.titleLabel?.font = UIFont(name: "\(fontName)-\(fontType)", size: CGFloat(fontSize))
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width/CGFloat(buttons.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = CGFloat(selectorRadius)
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height/2
    }
    
 
    
    @objc func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated(){
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button{
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                if animate{
                    UIView.animate(withDuration: 0.2) {
                        self.selector.frame.origin.x = selectorStartPosition
                    }
                }else {
                    selector.frame.origin.x = selectorStartPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }
    
}
