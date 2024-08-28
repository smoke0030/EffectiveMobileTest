//
//  ContentView.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 23.08.2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State var isPresentedAlert = false
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todos, id: \.id) { todo in
                    HStack {
                        VStack {
                            Text(todo.todo)
                        }
                        Spacer()
                        Button(action: {
                            viewModel.completeTodo(todo: todo)
                        }, label: {
                            Image(systemName: todo.completed ? "checkmark" : "square")
                        })
                    }
                }
                .onDelete(perform: { indexSet in
                    viewModel.deleteTodo(index: indexSet)
                })
            }
            .listStyle(.plain)
            .navigationTitle("Todo List")
            .navigationBarItems(trailing: Button(action: {
                isPresentedAlert.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(.black)
            }))
            .alert("Add Todo", isPresented: $isPresentedAlert) {
                TextField("Enter todo name", text: $name)
                Button("Add") {
                    viewModel.addTodo(name: name)
                    name = ""
                }
                Button("Cancel", role: .cancel) {}
            }
            .onAppear {
                viewModel.getTodos {
                    if viewModel.todos.isEmpty {
                        viewModel.getData()
                    }
                }
            }
            
        }
        
        
        
    }
}

#Preview {
    MainView()
}
