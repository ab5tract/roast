use Test;
plan 15;
my $r;

=begin pod
    =begin code :allow<B>
    =end code
=end pod

$r = $=pod[0].contents[0];
isa_ok $r, Pod::Block::Code;
is $r.config<allow>, 'B';

=begin pod
    =config head2  :like<head1> :formatted<I>
=end pod

$r = $=pod[1].contents[0];
isa_ok $r, Pod::Config;
is $r.type, 'head2';
is $r.config<like>, 'head1';
is $r.config<formatted>, 'I';

=begin pod
    =for pod :number(42) :zebras :!sheep
=end pod

$r = $=pod[2].contents[0];
is $r.config<number>, 42;
is $r.config<zebras>.Bool, True;
is $r.config<sheep>.Bool, False;

=begin pod
=for DESCRIPTION :title<presentation template>
=                :author<John Brown> :pubdate(2011)
=end pod

$r = $=pod[3].contents[0];
is $r.config<title>, 'presentation template';
is $r.config<author>, 'John Brown';
is $r.config<pubdate>, 2011;

=begin pod
=for table :caption<Table of contents>
    foo bar
=end pod

$r = $=pod[4].contents[0];
isa_ok $r, Pod::Block::Table;
is $r.config<caption>, 'Table of contents';

=begin pod
    =begin code :allow<B>
    These words have some B<importance>.
    =end code
=end pod

$r = $=pod[5].contents[0].contents[1];
isa_ok $r, Pod::FormattingCode;
