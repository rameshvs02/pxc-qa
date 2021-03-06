# User settings
WORKDIR=/ssd
RQG_DIR=/ssd/randgen

# Internal settings
MTR_BT=$[$RANDOM % 300 + 1]

# If an option was given to the script, use it as part of the workdir name
if [ -z $1 ]; then
  WORKDIRSUB=$(echo $RANDOM$RANDOM$RANDOM | sed 's/..\(......\).*/\1/')
else
  WORKDIRSUB=$1
fi

# Check if random directory already exists & start run if not
if [ -d $WORKDIR/$WORKDIRSUB ]; then
  echo "Directory already exists. Retry.";
else
  mkdir $WORKDIR/$WORKDIRSUB
  mkdir $WORKDIR/$WORKDIRSUB/tmp
  export TMP=$WORKDIR/$WORKDIRSUB/tmp
  cd $RQG_DIR
  MTR_BUILD_THREAD=$MTR_BT; perl ./combinations.pl \
  --clean \
  --force \
  --parallel=6 \
  --run-all-combinations-once \
  --workdir=$WORKDIR/$WORKDIRSUB \
  --config=$RQG_DIR/conf/percona_qa/BT-16274/BT-16274.cc
fi
