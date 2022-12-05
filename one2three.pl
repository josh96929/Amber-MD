#!/usr/bin/perl

#perl one2three.pl input.txt > output.txt
#perl one2three.pl input.txt
#HIS is labeled as HIE

my %aa = (A=>'ALA',a=>'ALA',C=>'CYS',c=>'CYS',G=>'GLY',g=>'GLY',
         Y=>'TYR',y=>'TYR',M=>'MET',m=>'MET',L=>'LEU',l=>'LEU',
         R=>'ARG',r=>'ARG',N=>'ASN',n=>'ASN',D=>'ASP',d=>'ASP',
         Q=>'GLN',q=>'GLN',E=>'GLU',e=>'GLU',H=>'HIE',h=>'HIE',
         W=>'TRP',w=>'TRP',K=>'LYS',k=>'LYS',F=>'PHE',f=>'PHE',
         P=>'PRO',p=>'PRO',S=>'SER',s=>'SER',T=>'THR',t=>'THR',
         I=>'ILE',i=>'ILE',V=>'VAL',v=>'VAL');


my $let = $ARGV[0];
$let =~ s/\s//g;
my @aa = split /|/,$let;

foreach my $a (@aa)
{
        print $aa{$a}, " ";
}
