my $starts-with-protocol = rx:i/ ^https?\:\/\//;  

sub fix-protocol ($url)  is export {
    return "https://" ~ $url unless $url ~~ $starts-with-protocol;
}

# I use a dedicated method to remove all debugging messages prior to commit
sub dbug($message) {
    say "$message";
}

#error types
# Just string is provided: 
# ERROR: Malformed UTF-8 near byte 81 at line 1 col 2 
# TYPE: X::AdHoc

# ERROR: Stringification of a Buf is not done with 'Stringy'.  The 'decode'
# method should be used to convert a Buf to a Str. 
#  TYPE: X::Buf::AsStr
