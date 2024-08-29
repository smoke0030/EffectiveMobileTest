//
//  ContentView.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 23.08.2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todos, id: \.id) { todo in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(todo.todo)
                            Text(viewModel.formattedDate(date: todo.date ?? Date()))
                                .font(.system(size: 12))
                        }
                        Spacer()
                        Button(action: {
                            viewModel.completeTodo(todo: todo)
                        }, label: {
                            Image(systemName: todo.completed ? "checkmark" : "square")
                        })
                    }
                    .contextMenu {
                        Button(action: {
                            viewModel.editingTodo = todo
                            viewModel.name = todo.todo
                            viewModel.isEditing = true
                            viewModel.isPresentedAlert.toggle()
                        }) {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                    }
                }
                
                .onDelete(perform: { indexSet in
                    viewModel.deleteTodo(index: indexSet)
                })
            }
            .listStyle(.plain)
            .navigationTitle("Todo List")
            .navigationBarItems(trailing: Button(action: {
                viewModel.isPresentedAlert.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(.black)
            }))
            .alert(viewModel.isEditing ? "Edit todo" : "Add Todo", isPresented: $viewModel.isPresentedAlert) {
                TextField("Enter todo name", text: $viewModel.name)
                CustomButton(isEditing: viewModel.isEditing)
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
    
    @ViewBuilder
    
    func CustomButton(isEditing: Bool) -> some View {
            Button(viewModel.isEditing ? "Edit" : "Add") {
                if viewModel.isEditing {
                    viewModel.editTodo(id: viewModel.editingTodo?.id ?? Int(), newName: viewModel.name)
                    viewModel.isEditing = false
                } else {
                    viewModel.addTodo(name: viewModel.name)
                }
                viewModel.name = ""
            }
    }
}

#Preview {
    MainView()
}
