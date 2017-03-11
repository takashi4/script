#!/usr/bin/env perl

use strict;

my %TARGET_FILES = map {( qq{$_.rb} => 1 )}
                   qw{ hoge hige hage hoo bar };

my %files;
while (<>) {
  chomp;
  my ($name, $file) = split(q{,});
  next if (! $TARGET_FILES{$file});
  $files{$file} = $name;
}

my $file_num = keys %files;

my %names;
map { $names{$_}++ }
values %files;

map {
  my $percent = int( $names{$_}/$file_num*100 );
  print qq{$_:$percent%\n};
}
sort keys %names;
