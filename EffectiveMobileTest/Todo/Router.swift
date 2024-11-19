
import Foundation

class TODORouter {
    static func build() -> TODOView{
        let intrecator = TODOInteractor()
        let presenter = TODOPresenter(interactor: intrecator)
        let view = TODOView(presenter: presenter)
        intrecator.presenter = presenter
        return view
    }
}
