set -eux

TARGET=$1
MODE=$2
FILTER=$3

if [[ "$MODE" = "run" ]]; then
  GDB_COMMAND=""
  GTEST_ARGS=""
  HOME_TRICK="../../testing/run_with_dummy_home.py"
elif [[ "$MODE" = "debug" ]]; then 
  GDB_COMMAND="gdb --args"
  GTEST_ARGS="--single-process-tests"
  HOME_TRICK=""
else
  echo "Run modes are run or debug!"
  exit -1
fi

if [[ "$FILTER" != "all" ]]; then
  GTEST_FILTER=--gtest_filter=$FILTER
else
  GTEST_FILTER=""
fi

cd ~/git/chromium/src/out/Default
autoninja -C ~/git/chromium/src/out/Default $TARGET

$HOME_TRICK ../../testing/xvfb.py $GDB_COMMAND ./$TARGET $GTEST_ARGS $GTEST_FILTER
