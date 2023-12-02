use List::Util qw(max);

$sum += max(/(\d+) blue/g) * max(/(\d+) red/g) * max(/(\d+) green/g) for <>;

print "$sum\n";