use strict;
use warnings;

for (1..2000) {
  print <<LINE;
.w${_}\{width:${_}px !important;}
.h${_}\{height:${_}px !important;}
LINE
}
