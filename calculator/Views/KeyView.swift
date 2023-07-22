//
//  KeyView.swift
//  calculator
//
//  Created by Jose Vivas on 10-07-23.
//

import SwiftUI

struct KeyView: View {
    
    @State var value = "0"
    @State var isDecimal = false
    @State var runningNumber: Float = 0
    @State var currentOperation: Operation = .none
    @State private var changeColor = true
    @State private var errorDivideByZero = false
    
    let buttons : [[Keys]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .substract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        VStack{
            Spacer()
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(changeColor ? Color("Result").opacity(0.2) : Color.pink.opacity(0.2))
                    //.scaleEffect(changeColor ? 0.5 : 1.0)
                    .frame(width: 350, height: 280)
                    .animation(Animation.easeInOut.speed(0.17).repeatForever(), value: changeColor)
                    //.onAppear(perform: {
                        //self.blur = 20
                    //    self.changeColor.toggle()
                    //})
                    .overlay(Text(value)
                        .bold()
                        .font(.system(size: 100))
                    .foregroundColor(.black))
            }.padding()
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self){ elem in
                        Button {
                            self.didTap(button: elem)
                        } label: {
                            Text(elem.rawValue)
                                .font(.system(size: 30))
                                .frame(width: self.getWidth(elem: elem), height: self.getHeight(elem: elem))
                                .background(elem.buttonColor)
                                .foregroundColor(.black)
                                .cornerRadius(self.getWidth(elem: elem) / 2)
                                .shadow(color: .gray.opacity(0.8), radius: 5)
                        }

                    }
                }.padding(.bottom, 4)
                
            }
        }
        .alert("Error", isPresented: $errorDivideByZero) {} message: {
            Text("No se puede dividir entre 0")
        }
    }
    
    func getHeight(elem: Keys) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*10))/5
    }
    
    func getWidth(elem: Keys) -> CGFloat {
        if elem == .zero {
            return (UIScreen.main.bounds.width - (5*10))/2
        }
        return (UIScreen.main.bounds.width - (5*10))/4
    }
    
    func didTap(button: Keys) {
        switch button {
        case .add, .substract, .multiply, .divide, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Float(self.value) ?? 0
            }
            else if button == .substract {
                self.currentOperation = .substract
                self.runningNumber = Float(self.value) ?? 0
            }
            else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Float(self.value) ?? 0
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Float(self.value) ?? 0
            }
            else if button == .equal {
                let runningValue = self.runningNumber
                let currentValue = Float(self.value) ?? 0
                var result : Float = 0
                
                switch self.currentOperation {
                case .add:
                    result = runningValue + currentValue
                case .substract:
                    result = runningValue - currentValue
                case .multiply:
                    result = runningValue * currentValue
                case .divide:
                    if currentValue == 0 {
                        self.errorDivideByZero = true
                        break
                    }
                    result = runningValue / currentValue
                case .none:
                    break
                }
                
                if self.isDecimal {
                    self.value = "\(round(result * 100)/100)"
                }
                else
                {
                    self.value = "\(Int(round(result)))"
                }
                
            }
            if button != .equal {
                self.value = "0"
            }
        case .clear:
            self.value = "0"
            self.isDecimal = false
        case .decimal, .negative, .percent:
            let number = button.rawValue
            if button == .decimal {
                if !self.isDecimal {
                    self.isDecimal = true
                    self.value = "\(self.value)\(number)"
                }
            }
            else if button == .percent {
                let currentValue = Float(self.value) ?? 0
                let percent = self.runningNumber * (currentValue / 100)
                self.value = "\(percent)"
            }
            else if button == .negative {
                if self.value != "0" {
                    let number = (Float(self.value) ?? 0 ) - ((Float(self.value) ?? 0) * 2)
                    print(number)
                    self.value = "\(number)"
                }
            }
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            }
            else
            {
                self.value = "\(self.value)\(number)"
            }
        }
    }
}



struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView()
    }
}
