use v6;

use Test;

plan 28;

=begin description

This test tests the C<squish> builtin and .squish method on Any/List.

=end description

#?niecza skip 'NYI'
{
    my @array = <a b b c d e f f a>;
    is_deeply @array.squish,  <a b c d e f a>.list.item,
      "method form of squish works";
    is_deeply squish(@array), <a b c d e f a>.list.item,
      "subroutine form of squish works";
    is_deeply @array .= squish, [<a b c d e f a>],
      "inplace form of squish works";
    is_deeply @array, [<a b c d e f a>],
      "final result of in place";
} #4

{
    is_deeply squish(Any,'a', 'b', 'b', 'c', 'd', 'e', 'f', 'f', 'a'),
      (Any, <a b c d e f a>.list).list.item,
      'slurpy subroutine form of squish works';
} #1

#?niecza skip 'NYI'
{
    is 42.squish, 42,    ".squish can work on scalars";
    is (42,).squish, 42, ".squish can work on one-elem arrays";
} #2

#?niecza skip 'NYI'
{
    my class A { method Str { '' } };
    is (A.new, A.new).squish.elems, 2, 'squish has === semantics for objects';
} #1

#?niecza skip 'NYI'
{
    my @list = 1, "1";
    my @squish = squish(@list);
    is @squish, @list, "squish has === semantics for containers";
} #1

#?niecza skip 'NYI'
{
    my @a := squish( 1..Inf );
    is @a[3], 4, "make sure squish is lazy";
} #1

#?niecza skip 'NYI'
{
    my @array = <a b bb c d e f f a>;
    my $as    = *.substr: 0,1;
    is_deeply @array.squish(:$as),  <a b c d e f a>.list.item,
      "method form of squish with :as works";
    is_deeply squish(@array,:$as), <a b c d e f a>.list.item,
      "subroutine form of squish with :as works";
    is_deeply @array .= squish(:$as), [<a b c d e f a>],
      "inplace form of squish with :as works";
    is_deeply @array, [<a b c d e f a>],
      "final result with :as in place";
} #4

#?niecza skip 'NYI'
{
    my @array = <a aa b bb c d e f f a>;
    my $with  = { substr($^a,0,1) eq substr($^b,0,1) }
    is_deeply @array.squish(:$with),  <a b c d e f a>.list.item,
      "method form of squish with :with works";
    is_deeply squish(@array,:$with), <a b c d e f a>.list.item,
      "subroutine form of squish with :with works";
    is_deeply @array .= squish(:$with), [<a b c d e f a>],
      "inplace form of squish with :with works";
    is_deeply @array, [<a b c d e f a>],
      "final result with :with in place";
} #4

#?niecza skip 'NYI'
{
    my @array = <a aa b bb c d e f f a>;
    my $as    = *.substr(0,1).ord;
    my $with  = &[==];
    is_deeply @array.squish(:$as, :$with),  <a b c d e f a>.list.item,
      "method form of squish with :as and :with works";
    is_deeply squish(@array,:$as, :$with), <a b c d e f a>.list.item,
      "subroutine form of squish with :as and :with works";
    is_deeply @array .= squish(:$as, :$with), [<a b c d e f a>],
      "inplace form of squish with :as and :with works";
    is_deeply @array, [<a b c d e f a>],
      "final result with :as and :with in place";
} #4

#?niecza skip 'NYI'
{
    my @array = ({:a<1>}, {:a<1>}, {:b<1>});
    my $with  = &[eqv];
    is_deeply @array.squish(:$with),  ({:a<1>}, {:b<1>}).list.item,
      "method form of squish with [eqv] and objects works";
    is_deeply squish(@array,:$with), ({:a<1>}, {:b<1>}).list.item,
      "subroutine form of squish with [eqv] and objects works";
    is_deeply @array .= squish(:$with), [{:a<1>}, {:b<1>}],
      "inplace form of squish with [eqv] and objects works";
    is_deeply @array, [{:a<1>}, {:b<1>}],
      "final result with [eqv] and objects in place";
} #4

# RT #121434
{
    my $a = <a b b c>;
    $a .= squish;
    is_deeply( $a, <a b c>.list.item, '.= squish in sink context works on $a' );
    my @a = <a b b c>;
    @a .= squish;
    is_deeply( @a, [<a b c>], '.= squish in sink context works on @a' );
} #2

# vim: ft=perl6
