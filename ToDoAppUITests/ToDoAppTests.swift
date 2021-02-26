//
//  DarkModeEnabled.swift
//  ToDoAppUITests
//
//  Created by Magnus Ahlqvist on 2021-02-21.
//

import XCTest

class ToDoAppTests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        super.setUp()
        self.app = XCUIApplication()
        self.app.launch()
    }
    
    func test_should_add_task_to_the_list() {
        
        let addTaskButton = self.app.buttons["addTaskButton"]
        addTaskButton.tap()
        
        let taskNameTextField = self.app.textFields["taskNameTextField"]
        taskNameTextField.tap()
        taskNameTextField.typeText("Testar att skriva in något\n")
    
        let taskCount = self.app.tables.children(matching: .cell).count
        
        XCTAssertEqual(1, taskCount)
    }
    
    func test_display_text_ON() {
        
        app.buttons["DarkMode"].tap()
        
        let darkModeToggle = self.app.switches["darkModeToggle"]
        let darkModeText = self.app.staticTexts["darkModeText"]
        
        darkModeToggle.tap()
        
        XCTAssertEqual("ON", darkModeText.label)
    }
    
   

}
