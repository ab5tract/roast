use v6;
use Test;

plan 144;

sub showset($s) { $s.keys.sort.join(' ') }

sub showkv($x) {
    $x.keys.sort.map({ $^k ~ ':' ~ $x{$k} }).join(' ')
}

# "We're more of the love, blood, and rhetoric school. Well, we can do you blood
# and love without the rhetoric, and we can do you blood and rhetoric without
# the love, and we can do you all three concurrent or consecutive. But we can't
# give you love and rhetoric without the blood. Blood is compulsory. They're all
# blood, you see." -- Tom Stoppard

my $s = bag <blood love>;
my $ks = BagHash.new(<blood rhetoric>);
my $b = mix blood => 1.1, rhetoric => 1, love => 1.2;
my $kb = MixHash.new(blood => 1.1, love => 1.3);

# Mix Union

is showkv($b ∪ $b), showkv($b), "Mix union with itself yields self";
isa_ok ($b ∪ $b), Mix, "... and it's actually a Mix";
is showkv($kb ∪ $kb), showkv($kb), "MixHash union with itself yields (as Mix)";
isa_ok ($kb ∪ $kb), Mix, "... and it's actually a Mix";

is showkv($s ∪ $b), "blood:2 love:2 rhetoric:1", "Set union with Mix works";
isa_ok ($s ∪ $b), Mix, "... and it's actually a Mix";
is showkv($s ∪ $kb), "blood:1 love:2", "Set union with MixHash works";
isa_ok ($s ∪ $kb), Mix, "... and it's actually a Mix";

is showkv($s (|) $b), "blood:2 love:2 rhetoric:1", "Set union with Mix works (texas)";
isa_ok ($s (|) $b), Mix, "... and it's actually a Mix";
is showkv($s (|) $kb), "blood:1 love:2", "Set union with MixHash works (texas)";
isa_ok ($s (|) $kb), Mix, "... and it's actually a Mix";

# Mix Intersection

is showkv($b ∩ $b), showkv($b), "Mix intersection with itself yields self (as Mix)";
isa_ok ($b ∩ $b), Mix, "... and it's actually a Mix";
is showkv($kb ∩ $kb), showkv($kb), "MixHash intersection with itself yields self (as Mix)";
isa_ok ($kb ∩ $kb), Mix, "... and it's actually a Mix";

is showkv($s ∩ $b), "blood:1 love:1", "Set intersection with Mix works";
isa_ok ($s ∩ $b), Mix, "... and it's actually a Mix";
is showkv($s ∩ $kb), "blood:1 love:1", "Set intersection with MixHash works";
isa_ok ($s ∩ $kb), Mix, "... and it's actually a Mix";
#?niecza todo 'Right now this works as $kb ∩ glag ∩ green ∩ blood.  Test may be wrong'
is showkv($kb ∩ <glad green blood>), "blood:1", "MixHash intersection with array of strings works";
isa_ok ($kb ∩ <glad green blood>), Mix, "... and it's actually a Mix";

is showkv($s (&) $b), "blood:1 love:1", "Set intersection with Mix works (texas)";
isa_ok ($s (&) $b), Mix, "... and it's actually a Mix";
is showkv($s (&) $kb), "blood:1 love:1", "Set intersection with MixHash works (texas)";
isa_ok ($s (&) $kb), Mix, "... and it's actually a Mix";
#?niecza todo 'Right now this works as $kb ∩ glag ∩ green ∩ blood.  Test may be wrong?'
is showkv($kb (&) <glad green blood>), "blood:1", "MixHash intersection with array of strings works (texas)";
isa_ok ($kb (&) <glad green blood>), Mix, "... and it's actually a Mix";

# symmetric difference

sub symmetric-difference($a, $b) {
    ($a (|) $b) (-) ($b (&) $a)
}

#?rakudo 8 skip "Rakudo update in progress, but not done yet"

is showkv($s (^) $b), showkv(symmetric-difference($s, $b)), "Mix symmetric difference with Set is correct";
isa_ok ($s (^) $b), Mix, "... and it's actually a Mix";
is showkv($b (^) $s), showkv(symmetric-difference($s, $b)), "Set symmetric difference with Mix is correct";
isa_ok ($b (^) $s), Mix, "... and it's actually a Mix";

#?niecza todo "Test is wrong, implementation is wrong"
is showkv($s (^) $kb), showkv(symmetric-difference($s, $kb)), "MixHash symmetric difference with Set is correct";
isa_ok ($s (^) $kb), Mix, "... and it's actually a Mix";
#?niecza todo "Test is wrong, implementation is wrong"
is showkv($kb (^) $s), showkv(symmetric-difference($s, $kb)), "Set symmetric difference with MixHash is correct";
isa_ok ($kb (^) $s), Mix, "... and it's actually a Mix";

# Mix multiplication

is showkv($s ⊍ $s), "blood:1 love:1", "Mix multiplication with itself yields self squared";
isa_ok ($s ⊍ $s), Mix, "... and it's actually a Mix";
is showkv($ks ⊍ $ks), "blood:1 rhetoric:1", "Mix multiplication with itself yields self squared";
isa_ok ($ks ⊍ $ks), Mix, "... and it's actually a Mix";
is showkv($b ⊍ $b), "blood:4 love:4 rhetoric:1", "Mix multiplication with itself yields self squared";
isa_ok ($b ⊍ $b), Mix, "... and it's actually a Mix";
is showkv($kb ⊍ $kb), "blood:1 love:4", "Mix multiplication with itself yields self squared";
isa_ok ($kb ⊍ $kb), Mix, "... and it's actually a Mix";

is showkv($s ⊍ $ks), "blood:1", "Mix multiplication (Set / SetHash) works";
isa_ok ($s ⊍ $ks), Mix, "... and it's actually a Mix";
is showkv($s ⊍ $b), "blood:2 love:2", "Mix multiplication (Set / Mix) works";
isa_ok ($s ⊍ $b), Mix, "... and it's actually a Mix";
is showkv($ks ⊍ $b), "blood:2 rhetoric:1", "Mix multiplication (SetHash / Mix) works";
isa_ok ($ks ⊍ $b), Mix, "... and it's actually a Mix";
is showkv($kb ⊍ $b), "blood:2 love:4", "Mix multiplication (MixHash / Mix) works";
isa_ok ($kb ⊍ $b), Mix, "... and it's actually a Mix";

is showkv($s (.) $ks), "blood:1", "Mix multiplication (Set / SetHash) works (texas)";
isa_ok ($s (.) $ks), Mix, "... and it's actually a Mix (texas)";
is showkv($s (.) $b), "blood:2 love:2", "Mix multiplication (Set / Mix) works (texas)";
isa_ok ($s (.) $b), Mix, "... and it's actually a Mix (texas)";
is showkv($ks (.) $b), "blood:2 rhetoric:1", "Mix multiplication (SetHash / Mix) works (texas)";
isa_ok ($ks (.) $b), Mix, "... and it's actually a Mix (texas)";
is showkv($kb (.) $b), "blood:2 love:4", "Mix multiplication (MixHash / Mix) works (texas)";
isa_ok ($kb (.) $b), Mix, "... and it's actually a Mix";

# Mix addition

is showkv($s ⊎ $s), "blood:2 love:2", "Mix addition with itself yields twice self";
isa_ok ($s ⊎ $s), Mix, "... and it's actually a Mix";
is showkv($ks ⊎ $ks), "blood:2 rhetoric:2", "Mix addition with itself yields twice self";
isa_ok ($ks ⊎ $ks), Mix, "... and it's actually a Mix";
is showkv($b ⊎ $b), "blood:4 love:4 rhetoric:2", "Mix addition with itself yields twice self";
isa_ok ($b ⊎ $b), Mix, "... and it's actually a Mix";
is showkv($kb ⊎ $kb), "blood:2 love:4", "Mix addition with itself yields twice self";
isa_ok ($kb ⊎ $kb), Mix, "... and it's actually a Mix";

is showkv($s ⊎ $ks), "blood:2 love:1 rhetoric:1", "Mix addition (Set / SetHash) works";
isa_ok ($s ⊎ $ks), Mix, "... and it's actually a Mix";
is showkv($s ⊎ $b), "blood:3 love:3 rhetoric:1", "Mix addition (Set / Mix) works";
isa_ok ($s ⊎ $b), Mix, "... and it's actually a Mix";
is showkv($ks ⊎ $b), "blood:3 love:2 rhetoric:2", "Mix addition (SetHash / Mix) works";
isa_ok ($ks ⊎ $b), Mix, "... and it's actually a Mix";
is showkv($kb ⊎ $b), "blood:3 love:4 rhetoric:1", "Mix addition (MixHash / Mix) works";
isa_ok ($kb ⊎ $b), Mix, "... and it's actually a Mix";

is showkv($s (+) $ks), "blood:2 love:1 rhetoric:1", "Mix addition (Set / SetHash) works (texas)";
isa_ok ($s (+) $ks), Mix, "... and it's actually a Mix (texas)";
is showkv($s (+) $b), "blood:3 love:3 rhetoric:1", "Mix addition (Set / Mix) works (texas)";
isa_ok ($s (+) $b), Mix, "... and it's actually a Mix (texas)";
is showkv($ks (+) $b), "blood:3 love:2 rhetoric:2", "Mix addition (SetHash / Mix) works (texas)";
isa_ok ($ks (+) $b), Mix, "... and it's actually a Mix (texas)";
is showkv($kb (+) $b), "blood:3 love:4 rhetoric:1", "Mix addition (MixHash / Mix) works (texas)";
isa_ok ($kb (+) $b), Mix, "... and it's actually a Mix";

# for https://rt.perl.org/Ticket/Display.html?id=122810
ok mix(my @large_arr = ("a"...*)[^50000]), "... a large array goes into a bar - I mean mix - with 50k elems and lives";

# msubset
{
    ok $kb ≼ $b, "Our keymix is a msubset of our mix";
    nok $b ≼ $kb, "Our mix is not a msubset of our keymix";
    ok $b ≼ $b, "Our mix is a msubset of itself";
    ok $kb ≼ $kb, "Our keymix is a msubset of itself";
    #?niecza 4 skip '(<+) NYI - https://github.com/sorear/niecza/issues/178'
    ok $kb (<+) $b, "Our keymix is a msubset of our mix (texas)";
    nok $b (<+) $kb, "Our mix is not a msubset of our keymix (texas)";
    ok $b (<+) $b, "Our mix is a msubset of itself (texas)";
    ok $kb (<+) $kb, "Our keymix is a msubset of itself (texas)";
}

# msuperset
{
    nok $kb ≽ $b, "Our keymix is not a msuperset of our mix";
    ok $b ≽ $kb, "Our keymix is not a msuperset of our mix";
    ok $b ≽ $b, "Our mix is a msuperset of itself";
    ok $kb ≽ $kb, "Our keymix is a msuperset of itself";
    #?niecza 4 skip '(>+) NYI - https://github.com/sorear/niecza/issues/178'
    nok $kb (>+) $b, "Our keymix is not a msuperset of our mix";
    ok $b (>+) $kb, "Our mix is a msuperset of our keymix";
    ok $b (>+) $b, "Our mix is a msuperset of itself";
    ok $kb (>+) $kb, "Our keymix is a msuperset of itself";
}

{

    my $s     = mix e => 1.1;
    my $sub   = mix n => 2.2, e => 2.2, d => 2.2;
    my $super = mix n => 2.2, e => 4.4, d => 2.2, y => 2.2;

    ok $s ⊂ $sub, "⊂ - {$s.gist} is a strict submix of {$sub.gist}";
    ok $sub ⊄ $super, "⊄ - {$sub.gist} is not a strict submix of {$super.gist}";
    ok $sub ⊆ $super, "⊆ - {$sub.gist} is a submix of {$super.gist}";
    ok $super ⊈ $sub, "⊈ - {$super.gist} is not a submix of {$sub.gist}";
    ok $sub ⊃ $s, "⊃ - {$sub.gist} is a strict supermix of {$s.gist}";
    ok $super ⊅ $sub, "⊅ - {$super.gist} is not a strict supermix of {$sub.gist}";
    ok $super ⊇ $sub, "⊇ - {$super.gist} is a supermix of {$sub.gist}"; 
    ok $sub ⊉ $super, "⊉ - {$sub.gist} is not a supermix of {$super.gist}";
    ok $s (<) $sub, "(<) - {$s.gist} is a strict submix of {$sub.gist} (texas)";
    ok $sub !(<) $super, "!(<) - {$sub.gist} is not a strict submix of {$super.gist} (texas)";
    ok $sub (>) $s, "(>) - {$sub.gist} is a strict supermix of {$s.gist} (texas)";
    ok $super !(>) $sub, "!(>) - {$super.gist} is not a strict supermix of {$sub.gist}";
    ok $sub (<=) $super, "(<=) - {$sub.gist} submix {$super.gist} (texas)";
    ok $super !(<=) $sub, "!(<=) - {$super.gist} is not a submix of {$sub.gist} (texas)";
    ok $super (>=) $sub, "(>=) - {$super.gist} is a supermix of {$sub.gist} (texas)"; 
    ok $sub !(>=) $super, "!(>=) - {$sub.gist} is not a supermix of {$super.gist} (texas)";
}

{
    # my $s = set <blood love>;
    # my $ks = SetHash.new(<blood rhetoric>);
    # my $b = mix <blood blood rhetoric love love>;
    # my $kb = MixHash.new(<blood love love>);
    my @d;
    
    is showkv([⊎] @d), showkv(∅), "Mix sum reduce works on nothing";
    is showkv([⊎] $s), showkv($s.Mix), "Mix sum reduce works on one set";
    is showkv([⊎] $s, $b), showkv({ blood => 3, rhetoric => 1, love => 3 }), "Mix sum reduce works on two sets";
    is showkv([⊎] $s, $b, $kb), showkv({ blood => 4, rhetoric => 1, love => 5 }), "Mix sum reduce works on three sets";

    is showkv([(+)] @d), showkv(∅), "Mix sum reduce works on nothing";
    is showkv([(+)] $s), showkv($s.Mix), "Mix sum reduce works on one set";
    is showkv([(+)] $s, $b), showkv({ blood => 3, rhetoric => 1, love => 3 }), "Mix sum reduce works on two sets";
    is showkv([(+)] $s, $b, $kb), showkv({ blood => 4, rhetoric => 1, love => 5 }), "Mix sum reduce works on three sets";

    is showkv([⊍] @d), showkv(∅), "Mix multiply reduce works on nothing";
    is showkv([⊍] $s), showkv($s.Mix), "Mix multiply reduce works on one set";
    is showkv([⊍] $s, $b), showkv({ blood => 2, love => 2 }), "Mix multiply reduce works on two sets";
    is showkv([⊍] $s, $b, $kb), showkv({ blood => 2, love => 4 }), "Mix multiply reduce works on three sets";

    is showkv([(.)] @d), showkv(∅), "Mix multiply reduce works on nothing";
    is showkv([(.)] $s), showkv($s.Mix), "Mix multiply reduce works on one set";
    is showkv([(.)] $s, $b), showkv({ blood => 2, love => 2 }), "Mix multiply reduce works on two sets";
    is showkv([(.)] $s, $b, $kb), showkv({ blood => 2, love => 4 }), "Mix multiply reduce works on three sets";

    #?rakudo 5 skip "Crashing"
    is showkv([(^)] @d), showset(∅), "Mix symmetric difference reduce works on nothing";
    is showkv([(^)] $s), showset($s), "Set symmetric difference reduce works on one set";
    isa_ok showkv([(^)] $s), Set, "Set symmetric difference reduce works on one set, yields set";
    is showkv([(^)] $b), showkv($b), "Mix symmetric difference reduce works on one mix";
    isa_ok showkv([(^)] $b), Mix, "Mix symmetric difference reduce works on one mix, yields mix";
    #?rakudo 4 todo "Wrong answer at the moment"
    is showkv([(^)] $s, $b), showkv({ blood => 1, love => 1, rhetoric => 1 }), "Mix symmetric difference reduce works on a mix and a set";
    isa_ok showkv([(^)] $s, $b), Mix, "... and produces a Mix";
    is showkv([(^)] $b, $s), showkv({ blood => 1, love => 1, rhetoric => 1 }), "... and is actually symmetric";
    isa_ok showkv([(^)] $b, $s), Mix, "... and still produces a Mix that way too";
    #?rakudo 2 skip "Crashing"
    is showkv([(^)] $s, $b, $kb), showkv({ blood => 1, love => 1, rhetoric => 1 }), "Mix symmetric difference reduce works on three mixs";
    isa_ok showkv([(^)] $s, $b, $kb), Mix, "Mix symmetric difference reduce works on three mixs";
}

# vim: ft=perl6
