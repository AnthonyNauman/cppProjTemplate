#!/bin/bash

run_all_tests() {
	artifacts_dir=$1


	cov_folder=$artifacts_dir/coverage
	report_folder=$artifacts_dir/test_report
	cov_info_folder=$report_folder/coverage_info

	rm -rf $report_folder
	rm -rf $cov_info_folder
	mkdir -p $report_folder $cov_info_folder

	main_cov_info_file=$report_folder/main_coverage.info

	directory="$artifacts_dir/bin/tests"
	run_tests_with_report "$directory"

	# Test coverage
	lcov -c -d $cov_folder -o $main_cov_info_file
	genhtml $main_cov_info_file --output-directory $cov_info_folder
}

run_all_tests $1

