use Base64;
use Libarchive::Filter :gzip;

my $starts-with-protocol = rx:i/ ^https? '://'/;

sub fix-protocol(Str $url) is export {
    return "http://" ~ $url unless $url ~~ $starts-with-protocol;

    return $url;
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

sub hyperlink(Str $return-url --> Str) is export {
    encode-base64(gzip($return-url), :str)
}

sub redirect(Str $return-url --> Str) is export {
    gunzip(decode-base64($return-url, :bin));
}
