#include <iostream>
#include <optional>
#include <string>

#include "someClass.h"

std::optional<int> getValue(bool shouldReturn)
{
    if (shouldReturn) {
        return 42; // Если истина, возвращаем значение
    } else {
        return std::nullopt; // В противном случае возвращаем пустое значение
    }
}

int main()
{
    auto value = getValue(true);

    if (value.has_value()) {
        std::cout << "Полученное значение: " << value.value() << std::endl;
    } else {
        std::cout << "Значение отсутствует." << std::endl;
    }

    SomeClass   sc;
    std::string str = std::to_string(sc.sum(4, 11));
    std::cout << "Test App " << str << std::endl;

    return 0;
}