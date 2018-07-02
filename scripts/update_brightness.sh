BACKLIGHT=$(xbacklight -get)
CHANGE=10

echo $BACKLIGHT

if [ $(echo $BACKLIGHT'<'5 | bc -l) -eq 1 ];
then
  CHANGE=0.25;
elif [ $(echo $BACKLIGHT'<'30 | bc -l) -eq 1 ];
then
  CHANGE=5;
fi

if [ "$1" == "dec" ] && [ $(echo $(xbacklight -get)'>'0.12 | bc -l) ];
then
  xbacklight -dec $CHANGE;
elif [ "$1" == "inc" ];
then
  if [ $(echo $(xbacklight -get)'<'0.1 | bc -l) -eq 1 ];
  then
    xbacklight -set 0.12;
  else
    xbacklight -inc $CHANGE;
  fi
fi;

echo $(xbacklight -get)
