//
//  ToDoAppUITests.swift
//  ToDoAppUITests
//
//  Created by robin karlsson on 2020-11-25.
//

import XCTest

class when_the_user_types_task_name_and_press_add_button: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        self.app = XCUIApplication()
        self.app.launch()
    }

    
    func test_should_add_task_to_the_list() {
        
        let addTaskButton = self.app.buttons["addTaskButton"]
        addTaskButton.tap()
        
        let taskNameTextField = self.app.textFields["taskNameTextField"]
        taskNameTextField.tap()
        taskNameTextField.typeText("Testar \n")
    
        let taskCount = self.app.tables.children(matching: .cell).count
        
        XCTAssertEqual(1, taskCount)
    }
}


