#include <iostream>
#include <string>

#include "someClass.h"

#include <nlohmann/json.hpp>

#include <optional>

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

    const auto  json = nlohmann::json::parse("{}");
    std::string str = "aaa";
    std::cout << "Test App " << str << std::endl;

    return 0;
}