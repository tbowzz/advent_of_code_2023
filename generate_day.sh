#!/bin/bash

DAY=$1

SOLVER_FILE="day_${DAY}.rb"
cp solver_template.txt $SOLVER_FILE
sed -i '' "s/XX/$DAY/g" "$SOLVER_FILE"

INPUT_FILE="day_${DAY}_input.txt"
touch $INPUT_FILE
TEST_INPUT_FILE="day_${DAY}_test_input.txt"
touch $TEST_INPUT_FILE
