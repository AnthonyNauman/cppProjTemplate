#include <gtest/gtest.h>

#include <someClass.h>

TEST(Test, unitTestName1)
{
    ASSERT_TRUE(3 == 3);
    ASSERT_TRUE(1 == 1);
}

TEST(Test, unitTestName2)
{
    ASSERT_TRUE(3 * 4 == (3 * 2 * 2));
    ASSERT_FALSE(3 * 5 == 3);
}

int main(int argc, char** argv)
{
    SomeClass sc;
    auto      res = sc.sum(5, 4);
    testing::InitGoogleTest(&argc, argv);
    const auto status = RUN_ALL_TESTS();

    return status;
}