//  CustomCells.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit
import MapKit
import Eureka

//MARK: FloatLabelCell

public class _FloatLabelCell<T where T: Equatable, T: InputTypeInitiable>: Cell<T>, UITextFieldDelegate, TextFieldCell {
        
    public var textField : UITextField { return floatLabelTextField }

    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    lazy public var floatLabelTextField: FloatLabelTextField = { [unowned self] in
        let floatTextField = FloatLabelTextField()
        floatTextField.translatesAutoresizingMaskIntoConstraints = false
        floatTextField.font = .preferredFontForTextStyle(UIFontTextStyleBody)
        floatTextField.titleFont = .boldSystemFontOfSize(11.0)
        floatTextField.clearButtonMode = .WhileEditing
        return floatTextField
        }()
    
    
    public override func setup() {
        super.setup()
        height = { 55 }
        selectionStyle = .None
        contentView.addSubview(floatLabelTextField)
        floatLabelTextField.delegate = self
        floatLabelTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
        contentView.addConstraints(layoutConstraints())
    }
    
    public override func update() {
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        floatLabelTextField.attributedPlaceholder = NSAttributedString(string: row.title ?? "", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        floatLabelTextField.text =  row.displayValueFor?(row.value)
        floatLabelTextField.enabled = !row.isDisabled
        floatLabelTextField.titleTextColour = .lightGrayColor()
        floatLabelTextField.alpha = row.isDisabled ? 0.6 : 1
    }
    
    public override func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled && floatLabelTextField.canBecomeFirstResponder()
    }
    
    public override func cellBecomeFirstResponder() -> Bool {
        return floatLabelTextField.becomeFirstResponder()
    }
    
    public override func cellResignFirstResponder() -> Bool {
        return floatLabelTextField.resignFirstResponder()
    }
    
    private func layoutConstraints() -> [NSLayoutConstraint] {
        let views = ["floatLabeledTextField": floatLabelTextField]
        let metrics = ["vMargin":8.0]
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|-[floatLabeledTextField]-|", options: .AlignAllBaseline, metrics: metrics, views: views) + NSLayoutConstraint.constraintsWithVisualFormat("V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|", options: .AlignAllBaseline, metrics: metrics, views: views)
    }
    
    public func textFieldDidChange(textField : UITextField){
        guard let textValue = textField.text else {
            row.value = nil
            return
        }
        if let fieldRow = row as? FormatterConformance, let formatter = fieldRow.formatter where fieldRow.useFormatterDuringInput {
            let value: AutoreleasingUnsafeMutablePointer<AnyObject?> = AutoreleasingUnsafeMutablePointer<AnyObject?>.init(UnsafeMutablePointer<T>.alloc(1))
            let errorDesc: AutoreleasingUnsafeMutablePointer<NSString?> = nil
            if formatter.getObjectValue(value, forString: textValue, errorDescription: errorDesc) {
                row.value = value.memory as? T
                if var selStartPos = textField.selectedTextRange?.start {
                    let oldVal = textField.text
                    textField.text = row.displayValueFor?(row.value)
                    if let f = formatter as? FormatterProtocol {
                        selStartPos = f.getNewPosition(forPosition: selStartPos, inTextInput: textField, oldValue: oldVal, newValue: textField.text)
                    }
                    textField.selectedTextRange = textField.textRangeFromPosition(selStartPos, toPosition: selStartPos)
                }
                return
            }
        }
        guard !textValue.isEmpty else {
            row.value = nil
            return
        }
        guard let newValue = T.init(string: textValue) else {
            row.updateCell()
            return
        }
        row.value = newValue
    }
    
    //MARK: TextFieldDelegate
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        formViewController()?.beginEditing(self)
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        formViewController()?.endEditing(self)
    }
}

public class TextFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .Default
        textField.autocapitalizationType = .Sentences
        textField.keyboardType = .Default
    }
}


public class IntFloatLabelCell : _FloatLabelCell<Int>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .Default
        textField.autocapitalizationType = .None
        textField.keyboardType = .NumberPad
    }
}

public class PhoneFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.keyboardType = .PhonePad
    }
}

public class NameFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .No
        textField.autocapitalizationType = .Words
        textField.keyboardType = .NamePhonePad
    }
}

public class EmailFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .No
        textField.autocapitalizationType = .None
        textField.keyboardType = .EmailAddress
    }
}

public class PasswordFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .No
        textField.autocapitalizationType = .None
        textField.keyboardType = .ASCIICapable
        textField.secureTextEntry = true
    }
}

public class DecimalFloatLabelCell : _FloatLabelCell<Float>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.keyboardType = .DecimalPad
    }
}

public class URLFloatLabelCell : _FloatLabelCell<NSURL>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.keyboardType = .URL
    }
}

public class TwitterFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .No
        textField.autocapitalizationType = .None
        textField.keyboardType = .Twitter
    }
}

public class AccountFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .No
        textField.autocapitalizationType = .None
        textField.keyboardType = .ASCIICapable
    }
}



//MARK: FloatLabelRow

public class FloatFieldRow<T: Any, Cell: CellType where Cell: BaseCell, Cell: TextFieldCell, Cell.Value == T>: Row<T, Cell> {

    public var formatter: NSFormatter?
    public var useFormatterDuringInput: Bool
    
    public required init(tag: String?) {
        useFormatterDuringInput = false
        super.init(tag: tag)
        self.displayValueFor = { [unowned self] value in
            guard let v = value else {
                return nil
            }
            if let formatter = self.formatter {
                if self.cell.textField.isFirstResponder() {
                    if self.useFormatterDuringInput {
                        return formatter.editingStringForObjectValue(v as! AnyObject)
                    }
                    else {
                        return String(v)
                    }
                }
                return formatter.stringForObjectValue(v as! AnyObject)
            }
            else{
                return String(v)
            }
        }
    }
}


public final class TextFloatLabelRow: FloatFieldRow<String, TextFloatLabelCell>, RowType {}
public final class IntFloatLabelRow: FloatFieldRow<Int, IntFloatLabelCell>, RowType {}
public final class DecimalFloatLabelRow: FloatFieldRow<Float, DecimalFloatLabelCell>, RowType {}
public final class URLFloatLabelRow: FloatFieldRow<NSURL, URLFloatLabelCell>, RowType {}
public final class TwitterFloatLabelRow: FloatFieldRow<String, TwitterFloatLabelCell>, RowType {}
public final class AccountFloatLabelRow: FloatFieldRow<String, AccountFloatLabelCell>, RowType {}
public final class PasswordFloatLabelRow: FloatFieldRow<String, PasswordFloatLabelCell>, RowType {}
public final class NameFloatLabelRow: FloatFieldRow<String, NameFloatLabelCell>, RowType {}
public final class EmailFloatLabelRow: FloatFieldRow<String, EmailFloatLabelCell>, RowType {}
