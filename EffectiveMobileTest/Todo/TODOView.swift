import SwiftUI

struct TODOView: View {
    
    @StateObject var presenter: TODOPresenter
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $presenter.searchText)
                    .padding(10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            List {
                ForEach(presenter.filteredItems, id: \.id) { todo in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(todo.todo)
                            Text(presenter.formattedDate(date: todo.date ?? Date()))
                                .font(.system(size: 12))
                        }
                        Spacer()
                        Button(action: {
                            presenter.completeTodo(todo: todo)
                        }, label: {
                            Image(systemName: todo.completed ? "checkmark" : "square")
                        })
                    }
                    .contextMenu {
                        Button(action: {
                            presenter.editingTodo = todo
                            presenter.name = todo.todo
                            presenter.isEditing = true
                            presenter.isPresentedAlert.toggle()
                        }) {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            guard let index = presenter.todos.firstIndex(where: { $0.id == todo.id }) else { return }
                            let indexSet = IndexSet(integer: index)
                            presenter.deleteTodo(with: indexSet)
                        } label: {
                            Text("Delete")
                            Image(systemName: "minus.circle")
                        }
                    }
                }
                
                .onDelete(perform: { indexSet in
                    presenter.deleteTodo(with: indexSet)
                })
            }
            .listStyle(.plain)
            .navigationTitle("Todo List")
            .navigationBarItems(trailing: Button(action: {
                presenter.isPresentedAlert.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(.black)
            }))
            .alert(presenter.isEditing ? "Edit todo" : "Add Todo", isPresented: $presenter.isPresentedAlert) {
                TextField("Enter todo name", text: $presenter.name)
                CustomButton(isEditing: presenter.isEditing)
                Button("Cancel", role: .cancel) {}
            }
            .onAppear {
                presenter.getTodos()
            }
        }
        }
    }
    
    @ViewBuilder
    
    func CustomButton(isEditing: Bool) -> some View {
        Button(presenter.isEditing ? "Edit" : "Add") {
            if presenter.isEditing {
                presenter.editTodo(id: presenter.editingTodo?.id ?? Int(), newName: presenter.name)
                presenter.isEditing = false
            } else {
                presenter.addTodo(name: presenter.name)
            }
            presenter.name = ""
        }
    }
}
