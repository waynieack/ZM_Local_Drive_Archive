#!/usr/bin/perl

#############################################################################
# Name: zmlocalarchive.pl ZoneMinder archive to local drive
#
# Description: This script is for archiving Zoneminder events to a different local Drive
# 
# 
# Depends File::Copy::Recursive
#
# Author: Wayne Gatlin (wayne@razorcla.ws)
# $Revision: $
# $Date: $
#
##############################################################################
# Copyright       Wayne Gatlin, 2015, All rights reserved
##############################################################################
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
###############################################################################


use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove pathempty);
my $orig = $ARGV[1];
my $new = $ARGV[0];
my $arcfound = 0;
$new =~ s/\/$//;
$new = $new.$orig;

# `echo $orig $new >> /tmp/zm/testscript.log`;
if (-d $new) {
    $arcfound = 1;
    my $orig2 = $orig; $orig2 =~ s/\/$//;
    if( -l $orig2 ) { 
	`echo "Archive file $new and $orig2 symlink already exists" >> /tmp/zm/testscript.log`;
	exit; 
     }
}

if ($arcfound) { 
  if (&checkdir) { 
        pathempty($new) or die $!;
        rmdir $new or die $!;
	`echo "Archive file $new already exists but does not match, deleting Archive" >> /tmp/zm/testscript.log`;
   } else { 
   	pathempty($orig) or die $!;
        rmdir $orig or die $!;
        $orig =~ s/\/$//;
        $new =~ s/\/$//;
	symlink($new, $orig);
	`echo "Archive file $new already exists, creating symlink @ $orig" >> /tmp/zm/testscript.log`;
	exit;
   }  
}

if (rmove($orig,$new)) {
#print "Move $orig to $new Done";
	`echo "Move $orig to $new Done" >> /tmp/zm/testscript.log`;
	$orig =~ s/\/$//;
	$new =~ s/\/$//;
	symlink($new, $orig);
} else { 
#print "Move $orig to $new Failed";
	`echo "Move $orig to $new Failed" >> /tmp/zm/testscript.log`;
	pathempty($new) or die $!;
  	rmdir $new or die $!;
}

 
sub checkdir {
use File::DirCompare;

my $error = 0; 
File::DirCompare->compare($orig,$new,sub {
        my ($a,$b) = @_;
        if ( !$b or !$a ) {
		$error = 1;
               # printf "Test result:Failed.\n";
        }else {
		$error = 1;
                #printf "Test result:FAILED.\n";
        }
   });
return $error;
}

