#!/bin/bash
source $(dirname $0)/project_info.sh

cov_folder=$ARTIFACTS_DIR/coverage
report_folder=$ARTIFACTS_DIR/test_report
cov_info_folder=$report_folder/coverage_info

rm -rf $report_folder
rm -rf $cov_info_folder
mkdir -p $report_folder $cov_info_folder

main_cov_info_file=$report_folder/main_coverage.info

directory="$INSTALL_DIR/tests"
run_tests_with_report "$directory"

# Test coverage
lcov -c -d $cov_folder -o $main_cov_info_file
genhtml $main_cov_info_file --output-directory $cov_info_folder
