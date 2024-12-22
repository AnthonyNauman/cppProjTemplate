#include <gtest/gtest.h>
#include <someClass.h>

TEST(Test, unitTestName1)
{
    SomeClass sc;
    ASSERT_TRUE(3 == sc.sum(3, 0));
    ASSERT_TRUE(1 == sc.sum(2, -1));
}

TEST(Test, unitTestName2)
{
    SomeClass sc;
    ASSERT_TRUE(12 == (sc.sum(3, 9)));
    ASSERT_FALSE(15 == sc.sum(3, 5));
}

int main(int argc, char** argv)
{
    testing::InitGoogleTest(&argc, argv);
    const auto status = RUN_ALL_TESTS();

    return status;
}