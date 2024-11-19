### EffectiveMobileTest

EffectiveMobileTest - приложение для отслеживания задач, разработанное для iOS.

#### Описание

Пользователи могут создавать, изменять или удалять задачи
#### Инструкция по развёртыванию или использованию

Приложение при первом запуске получает данные из сети, поэтому для работы требуется подключение к интернету.

Для запуска приложения необходимо клонировать репозиторий и запустить проект в Xcode выполнив следующие шаги:

1. Клонировать репозиторий на локальную машину:

   ```shell
   git clone https://github.com/smoke0030/EffectiveMobileTest.git
   ```
2. Перейти в папку проекта, к примеру:

   ```shell
   cd ~/EffectiveMobileTest
   ```
3. Открыть проект с помощью Xcode.
4. Запустить проект на симуляторе или устройстве.

#### Системные требования

- Xcode 12.0 или выше
- Swift 5.3 или выше
- iOS 15.0 или выше
- Поддержка iPhone X и выше
- Адаптация под iPhone SE
- Предусмотрен только портретный режим
- Вёрстка iPad не предусмотрена

#### Стек технологий

Проект использует:

- Swift для разработки мобильного приложения.
- SwiftUI для построения пользовательского интерфейса.
- MVVM (Model-View-ViewModel) архитектура.
- Core Data и SQL для хранения данных.
- XCTestCase для unit - тестов

#### Настройка CI для запуска

Проект можно интегрировать с любой CI/CD системой, поддерживающей сборку проектов Swift и Xcode.

#### Создатели

Сергей Видишев
