use v6;
use Test;

plan 11;

# L<S03/Item assignment precedence/bind and make readonly>

{
    my $x = 5;
    my $y = 3;
    $x ::= $y;
    is $x, 3, '::= on scalars took the value from the RHS';
    #?rakudo todo 'nom regression'
    dies-ok { $x = 5 }; '... and made the LHS RO';
    #?rakudo todo 'nom regression'
    is $x, 3, 'variable is still 3';
}

{
    my Int $a = 4;
    my Str $b;
    dies-ok { $b ::= $a },
        'Cannot ro-bind variables with incompatible type constraints';
}

{
    my @x = <a b c>;
    my @y = <d e>;

    @x ::= @y;
    is @x.join('|'), 'd|e', '::= on arrays';
    #?rakudo 4 todo '::= on arrays'
    #?niecza todo
    dies-ok { @x := <3 4 foo> }, '... make RO';
    #?niecza todo
    is @x.join('|'), 'd|e', 'value unchanged';
    #?niecza todo
    lives_ok { @x[2] = 'k' }, 'can still assign to items of RO array';
    #?niecza todo
    is @x.join(''), 'd|e|k', 'assignment relly worked';
}

# RT #65900
{
    throws-like q[my $a is readonly = 5;], X::Comp::Trait::Unknown,
        'variable trait "is readonly" is no longer valid (1)';
    throws-like q[(my $a is readonly) = 5;], X::Comp::Trait::Unknown,
        'variable trait "is readonly" is no longer valid (2)';
}

# vim: ft=perl6
