 test1(){
 local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
    echo "if"
  else
    USING_ORG="${OVERRIDE_ORG}"
    echo "else"
  fi

echo $OVERRIDE_ORG
}

test1