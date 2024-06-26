#!/bin/bash
#
# Print the board state

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORK_DIR=$SCRIPT_DIR/..

BOARD_CONTRACT=$1
ACCOUNT_FILE=$2

RPC_URL=http://localhost:5050
CANVAS_CONFIG=$WORK_DIR/configs/canvas.config.json

# Get the board dimensions
BOARD_WIDTH=$(jq -r '.canvas.width' $CANVAS_CONFIG)
BOARD_HEIGHT=$(jq -r '.canvas.height' $CANVAS_CONFIG)
echo "Board dimensions: $BOARD_WIDTH x $BOARD_HEIGHT"

COLOR_COUNT=$(jq -r '.colors[]' $CANVAS_CONFIG | wc -l)
RAND_X=$(shuf -i 0-$((BOARD_WIDTH-1)) -n 1)
RAND_Y=$(shuf -i 0-$((BOARD_HEIGHT-1)) -n 1)
RAND_POS=$(($RAND_X + $RAND_Y * $BOARD_WIDTH))
RAND_COLOR=$(shuf -i 0-$((COLOR_COUNT-1)) -n 1)
echo "Placing pixel at ($RAND_X, $RAND_Y) with color $RAND_COLOR"

# Place a pixel
# ~/.art-peace-tests/tmp/1711605675/starknet_accounts.json
#$(ls $HOME/.l2-place-test/tmp/*/madara-dev-account.json)
#ACCOUNT_FILE=~/.art-peace-tests/tmp/1711682661/starknet_accounts.json
ACCOUNT_NAME=art_peace_acct
echo "Placing pixel at ($RAND_X, $RAND_Y) with color $RAND_COLOR - POS: $RAND_POS"
sncast --url $RPC_URL --accounts-file $ACCOUNT_FILE --account $ACCOUNT_NAME invoke --contract-address $BOARD_CONTRACT --function place_pixel --calldata $RAND_POS $RAND_COLOR
#echo "starkli invoke $BOARD_CONTRACT place_pixel $RAND_X $RAND_Y $RAND_COLOR --rpc $RPC_URL --account $ACCOUNT_FILE --keystore $KEYSTORE_FILE --keystore-password $KEYSTORE_PASSWORD"

# TODO: alternate async version
